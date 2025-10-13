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

    // You can customize refresh path via init.
    private let refreshPath: String

    init(tokenStore: AuthTokenStoreable, refreshPath: String = "/auth/refresh") {
        self.tokenStore = tokenStore
        self.refreshPath = refreshPath
    }

    /// Inject Authorization header
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        if request.value(forHTTPHeaderField: "Authorization") == nil, let token = tokenStore.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(request))
    }

    /// 401 - refreshing token
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }

        lock.lock(); defer { lock.unlock() }
        requestsToRetry.append(completion)

        guard !isRefreshing else { return }
        isRefreshing = true

        refreshTokens(using: session) { [weak self] succeeded in
            guard let self else { return }
            
            self.lock.lock(); defer { self.lock.unlock() }
            self.isRefreshing = false
            
            let results: [RetryResult] = succeeded
            ? Array(repeating: .retry, count: self.requestsToRetry.count)
            : Array(repeating: .doNotRetry, count: self.requestsToRetry.count)
            
            self.requestsToRetry.forEach { $0(results.first ?? .doNotRetry) }
            self.requestsToRetry.removeAll()
        }
    }

    private func refreshTokens(using session: Session, completion: @escaping (Bool) -> Void) {
        guard let baseURLString = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String, let baseURL = URL(string: baseURLString) else {
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
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: String] = ["refreshToken": refreshToken]
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)

        session.request(urlRequest)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: RefreshResponse.self) { [weak self] response in
                guard let self else { return }
                
                switch response.result {
                case .success(let model):
                    self.tokenStore.accessToken = model.accessToken
                    if let newRefresh = model.refreshToken { self.tokenStore.refreshToken = newRefresh }
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
    let refreshToken: String?
}
