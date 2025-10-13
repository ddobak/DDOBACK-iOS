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
    private let excludedSuffixes: [String] = [
        "auth/apple/login",
        "auth/login",
        "auth/refresh"
    ]

    private let maxRetryCount: Int
    private let refreshPath: String

    /// refresh 전용 세션 (interceptor 제거 → 재귀 방지)
    private lazy var refreshSession: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 15
        return Session(configuration: configuration)
    }()

    init(
        tokenStore: AuthTokenStoreable,
        refreshPath: String = "auth/refresh",
        maxRetryCount: Int = 1
    ) {
        self.tokenStore = tokenStore
        self.refreshPath = refreshPath
        self.maxRetryCount = maxRetryCount
    }

    // MARK: - Helpers
    private func isExcluded(_ url: URL?) -> Bool {
        let path = (url?.path ?? "").trimmingCharacters(in: CharacterSet(charactersIn: "/")).lowercased()
        return excludedSuffixes.contains { path.hasSuffix($0.lowercased()) }
    }

    private func makeRefreshURL() -> URL? {
        guard
            let base = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String,
            let baseURL = URL(string: base)
        else { return nil }
        let component = refreshPath.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        return baseURL.appendingPathComponent(component)
    }

    // MARK: - Adapter
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var req = urlRequest

        if let url = req.url, isExcluded(url) {
            return completion(.success(req))
        }

        guard let token = tokenStore.accessToken, !token.isEmpty else {
            return completion(.success(req))
        }

        /// 토큰 주입
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        completion(.success(req))
    }

    // MARK: - Retrier
    func retry(_ request: Request, for session: Session,
               dueTo error: Error, completion: @escaping (RetryResult) -> Void) {

        guard request.retryCount < maxRetryCount else {
            return completion(.doNotRetry)
        }

        guard let http = request.task?.response as? HTTPURLResponse else {
            return completion(.doNotRetry)
        }

        /// 401/403이 아닌 경우에는 retry하지 않음
        guard http.statusCode == 401 || http.statusCode == 403 else {
            return completion(.doNotRetry)
        }

        /// 인증 관련 endpoint 재시도 방어 코드
        if isExcluded(request.request?.url) {
            return completion(.doNotRetry)
        }

        /// refresh
        Task {
            let ok = await self.refreshTokens()
            completion(ok ? .retry : .doNotRetry)
        }
    }

    // MARK: - Refresh
    private func refreshTokens() async -> Bool {
        guard let url = makeRefreshURL(),
              let refreshToken = tokenStore.refreshToken, !refreshToken.isEmpty else {
            return false
        }

        var req = URLRequest(url: url)
        req.method = .post
        req.setValue(refreshToken, forHTTPHeaderField: "Refresh-Token")

        do {
            let dto = try await refreshSession.request(req)
                .validate(statusCode: 200..<300)
                .serializingDecodable(ResponseDTO<RefreshResponse>.self)
                .value

            guard let data = dto.data else {
                return false
            }

            tokenStore.accessToken = data.accessToken
            tokenStore.refreshToken = data.refreshToken
            return true
            
        } catch {
            return false
        }
    }
}

// MARK: - RefreshResponse
private struct RefreshResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}
