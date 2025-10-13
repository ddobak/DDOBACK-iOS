//
//  APIClient.swift
//  DDOBAK
//
//  Created by 이건우 on 7/10/25.
//

import Foundation
import Alamofire

// MARK: - APIClient Implementation (Alamofire)

final class APIClient: APIClientInterface {

    static let shared = APIClient()

    private let session: Session
    private let tokenStore: AuthTokenStoreable

    private let baseURL: URL

    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    private init() {
        guard
            let base = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String,
            let url = URL(string: base)
        else {
            fatalError("❌ Invalid or missing BASE_URL in Info.plist")
        }

        self.baseURL = url

        /// `Encoder` 설정
        let enc = JSONEncoder()
        enc.dateEncodingStrategy = .iso8601
        self.encoder = enc

        /// `Decoder` 설정
        let dec = JSONDecoder()
        dec.dateDecodingStrategy = .iso8601
        self.decoder = dec

        /// `TokenStore` 설정
        let tokenStore = KeyChainTokenStore()
        self.tokenStore = tokenStore

        /// `Interceptor(RefreshToken)` 설정
        let interceptor = AuthInterceptor(tokenStore: tokenStore)
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60

        #if DEBUG
        /// `NetworkLogger` 설정 (DEBUG ONLY)
        let logger = NetworkLogger()
        self.session = Session(configuration: configuration,
                               interceptor: interceptor,
                               eventMonitors: [logger])
        #else
        self.session = Session(configuration: configuration,
                               interceptor: interceptor)
        #endif
    }

    // MARK: - Public Request
    func request<T: Decodable>(
        path: String,
        method: HTTPMethod,
        headers: [String: String] = [:],
        queryItems: [URLQueryItem]? = nil,
        body: Encodable? = nil
    ) async throws -> ResponseDTO<T> {

        let url = try makeURL(path: path, query: queryItems)

        var urlRequest = URLRequest(url: url)
        urlRequest.method = method.toAF()

        // headers
        headers.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }

        // body
        if let body = body {
            urlRequest.httpBody = try encoder.encode(AnyEncodable(body))
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }

        let response = await session.request(urlRequest)
            .validate(statusCode: 200..<300)
            .serializingDecodable(ResponseDTO<T>.self, decoder: decoder)
            .response

        switch response.result {
        case .success(let dto):
            return dto

        case .failure(let afError):
            /// 204 No Content 같은 경우 data가 없어서 실패로 들어올 수 있음
            /// 서버가 wrapper를 항상 주지 않는다면 추가할 것.
            // if let http = response.response, http.statusCode == 204 {
            //     return ResponseDTO<T>(success: true,
            //                           code: http.statusCode,
            //                           message: "No Content",
            //                           userMessage: nil,
            //                           data: nil,
            //                           timestamp: nil,
            //                           traceId: nil)
            // }

            if let code = response.response?.statusCode {
                throw APIError.statusCode(code)
            } else {
                throw APIError.unknown(afError)
            }
        }
    }

    // MARK: - Multipart Request
    func requestMultipart<T: Decodable>(
        path: String,
        method: HTTPMethod = .post,
        headers: [String: String] = [:],
        parts: [MultipartPart]
    ) async throws -> ResponseDTO<T> {

        let url = baseURL.appendingPathComponent(path)
        let afHeaders = HTTPHeaders(headers.map { HTTPHeader(name: $0.key, value: $0.value) })

        let response = await session.upload(multipartFormData: { form in
            for part in parts {
                if let filename = part.filename, let mime = part.mimeType {
                    form.append(part.data, withName: part.name, fileName: filename, mimeType: mime)
                } else {
                    form.append(part.data, withName: part.name)
                }
            }
        }, to: url, method: method.toAF(), headers: afHeaders)
        .validate(statusCode: 200..<300)
        .serializingDecodable(ResponseDTO<T>.self, decoder: decoder)
        .response

        switch response.result {
        case .success(let dto):
            return dto
        case .failure(let afError):
            if let code = response.response?.statusCode {
                throw APIError.statusCode(code)
            } else {
                throw APIError.unknown(afError)
            }
        }
    }

    // MARK: - Helpers
    private func makeURL(path: String, query: [URLQueryItem]?) throws -> URL {
        guard var comps = URLComponents(url: baseURL.appendingPathComponent(path),
                                        resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }
        comps.queryItems = query
        guard let url = comps.url else { throw APIError.invalidURL }
        return url
    }
}

// MARK: - AnyEncodable Wrapper
private struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    init(_ value: Encodable) { _encode = value.encode }
    func encode(to encoder: Encoder) throws { try _encode(encoder) }
}

// MARK: - HTTPMethod Mapping
private extension HTTPMethod {
    func toAF() -> Alamofire.HTTPMethod {
        switch self {
        case .get: return .get
        case .post: return .post
        case .put: return .put
        case .delete: return .delete
        case .patch: return .patch
        }
    }
}

// MARK: - String + PathComponent Helper
private extension String {
    func appendingPathComponentSafe(_ path: String) throws -> URL {
        guard let base = URL(string: self) else { throw APIError.invalidURL }
        return base.appendingPathComponent(path)
    }
}
