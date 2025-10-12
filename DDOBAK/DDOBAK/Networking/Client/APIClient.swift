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
    private let tokenStore: TokenStore

    private init() {
        let tokenStore = DefaultTokenStore()
        self.tokenStore = tokenStore

        let interceptor = AuthInterceptor(tokenStore: tokenStore)
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60

        let logger = NetworkLogger()
        self.session = Session(configuration: configuration, interceptor: interceptor, eventMonitors: [logger])
    }

    // MARK: - Public Request
    func request<T: Decodable>(
        path: String,
        method: HTTPMethod,
        headers: [String: String] = [:],
        queryItems: [URLQueryItem]? = nil,
        body: Encodable? = nil
    ) async throws -> ResponseDTO<T> {

        let baseURLString = try Self.baseURLString()
        guard var components = URLComponents(string: baseURLString + path) else { throw APIError.invalidURL }
        components.queryItems = queryItems
        guard let url = components.url else { throw APIError.invalidURL }

        var urlRequest = URLRequest(url: url)
        urlRequest.method = method.toAF()

        // set headers
        headers.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }

        if let body = body {
            urlRequest.httpBody = try JSONEncoder().encode(AnyEncodable(body))
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let dataResponse = await session.request(urlRequest)
            .validate(statusCode: 200..<300)
            .serializingData()
            .response

        switch dataResponse.result {
        case .success(let data):
            do {
                let decoded = try JSONDecoder().decode(ResponseDTO<T>.self, from: data)
                return decoded
            } catch {
                error.handleDecodingError()
                throw APIError.decoding(error)
            }
        case .failure:
            if let statusCode = dataResponse.response?.statusCode {
                throw APIError.statusCode(statusCode)
            } else {
                throw APIError.invalidResponse
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

        let baseURLString = try Self.baseURLString()
        let url = try baseURLString.appendingPathComponentSafe(path)

        let afHeaders = HTTPHeaders(headers.map { HTTPHeader(name: $0.key, value: $0.value) })

        let dataResponse = await session.upload(multipartFormData: { formData in
            for part in parts {
                if let filename = part.filename, let mimeType = part.mimeType {
                    formData.append(part.data, withName: part.name, fileName: filename, mimeType: mimeType)
                } else {
                    formData.append(part.data, withName: part.name)
                }
            }
        }, to: url, method: method.toAF(), headers: afHeaders)
        .validate(statusCode: 200..<300)
        .serializingData()
        .response

        switch dataResponse.result {
        case .success(let data):
            do {
                let decoded = try JSONDecoder().decode(ResponseDTO<T>.self, from: data)
                return decoded
            } catch {
                throw APIError.decoding(error)
            }
        case .failure:
            if let statusCode = dataResponse.response?.statusCode {
                throw APIError.statusCode(statusCode)
            } else {
                throw APIError.invalidResponse
            }
        }
    }

    // MARK: - Helpers
    private static func baseURLString() throws -> String {
        guard let baseURLString = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String, URL(string: baseURLString) != nil else {
            fatalError("❌ Invalid or missing BASE_URL in Info.plist")
        }
        return baseURLString
    }
}

// MARK: - AnyEncodable Wrapper
private struct AnyEncodable: Encodable {
    private let encodeFunc: (Encoder) throws -> Void
    init(_ value: Encodable) {
        self.encodeFunc = value.encode
    }
    func encode(to encoder: Encoder) throws { try encodeFunc(encoder) }
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
