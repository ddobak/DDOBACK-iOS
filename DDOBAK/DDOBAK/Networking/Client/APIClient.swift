//
//  APIClient.swift
//  DDOBAK
//
//  Created by 이건우 on 7/10/25.
//

import Foundation

// MARK: - APIClient Implementation

final class APIClient: APIClientInterface {
    
    static let shared = APIClient()
    private init() {}

    private let session = URLSession.shared

    func request<T: Decodable>(
        path: String,
        method: HTTPMethod = .get,
        headers: [String: String] = [:],
        queryItems: [URLQueryItem]? = nil,
        body: Encodable? = nil
    ) async throws -> ResponseDTO<T> {

        guard let baseURLString = Bundle.main.infoDictionary?["BASE_URL"] as? String,
              let _ = URL(string: baseURLString) else {
            fatalError("❌ Invalid or missing BASE_URL in Info.plist")
        }
        
        guard var urlComponents = URLComponents(string: baseURLString + path) else {
            throw APIError.invalidURL
        }

        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.statusCode(httpResponse.statusCode)
        }

        do {
            let decoded = try JSONDecoder().decode(ResponseDTO<T>.self, from: data)
            return decoded
        } catch {
            error.handleDecodingError()
            throw APIError.decoding(error)
        }
    }
}
