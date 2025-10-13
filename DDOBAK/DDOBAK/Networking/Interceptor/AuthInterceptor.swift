//
//  AuthInterceptor.swift
//  DDOBAK
//
//  Created by 이건우 on 12/10/25.
//

import Foundation
import Alamofire

// MARK: - AuthInterceptor
final class AuthInterceptor: RequestInterceptor {
    
    private let tokenStore: AuthTokenStoreable
    private let lock = NSLock()
    private var isRefreshing = false
    private var requestsToRetry: [(RetryResult) -> Void] = []
    
    private let authPaths: Set<String> = ["auth/apple/login", "auth/login", "auth/refresh"]
    private func normalizedPath(from request: Request) -> String {
        request.request?.url?.path.trimmingCharacters(in: CharacterSet(charactersIn: "/")) ?? ""
    }
    
    private let refreshPath: String

    init(
        tokenStore: AuthTokenStoreable,
        refreshPath: String = "/auth/refresh"
    ) {
        self.tokenStore = tokenStore
        self.refreshPath = refreshPath
    }

    /// Inject Authorization header
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var request = urlRequest
        
        if let token = tokenStore.accessToken, !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        completion(.success(request))
    }

    /// 401 - refreshing token
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        
        /// auth 관련 요청 재시도 방지 로직 (무한루프 방지)
        let path = normalizedPath(from: request)
        if authPaths.contains(path) {
            return completion(.doNotRetry)
        }
        
        /// 상태코드가 없으면 재시도 안 함
        guard let statusCode = (request.task?.response as? HTTPURLResponse)?.statusCode else {
            return completion(.doNotRetry)
        }
        
        /// `401/403` 일때 토큰 갱신, 그 외는 재시도 안 함
        guard statusCode == 401 || statusCode == 403 else {
            return completion(.doNotRetry)
        }
        
        /// 동시성 제어: 모든 대기자를 큐에 쌓고, refresh 1회만 수행
        lock.lock()
        requestsToRetry.append(completion)
        let shouldStartRefresh = !isRefreshing
        if shouldStartRefresh { isRefreshing = true }
        lock.unlock()
        
        /// 이미 누군가 갱신 중
        guard shouldStartRefresh else { return }
        
        refreshTokens(using: session) { [weak self] succeeded in
            guard let self else { return }
            self.lock.lock()
            let completions = self.requestsToRetry
            self.requestsToRetry.removeAll()
            self.isRefreshing = false
            self.lock.unlock()
            
            let result: RetryResult = succeeded ? .retry : .doNotRetry
            completions.forEach { $0(result) }
        }
    }

    private func refreshTokens(
        using session: Session,
        completion: @escaping (Bool) -> Void
    ) {
        guard let baseURLString = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String,
              let baseURL = URL(string: baseURLString)
        else {
            completion(false)
            return
        }
        guard let refreshToken = tokenStore.refreshToken else {
            completion(false)
            return
        }

        let url = baseURL.appendingPathComponent(refreshPath)
        var urlRequest = URLRequest(url: url)
        urlRequest.method = .post
        urlRequest.setValue(refreshToken, forHTTPHeaderField: "Refresh-Token")

        session.request(urlRequest)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ResponseDTO<RefreshResponse>.self) { [weak self] response in
                guard let self else { return }
                
                switch response.result {
                case .success(let model):
                    
                    guard let responseData = model.data else { return }
                    self.tokenStore.accessToken = responseData.accessToken
                    self.tokenStore.refreshToken = responseData.refreshToken
                    completion(true)
                    
                case .failure:
                    self.tokenStore.clear()
                    completion(false)
                }
            }
    }
}

// MARK: - RefreshResponse DTO
private struct RefreshResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}
