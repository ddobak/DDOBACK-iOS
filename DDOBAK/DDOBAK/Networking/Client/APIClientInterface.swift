//
//  APIClientInterface.swift
//  DDOBAK
//
//  Created by 이건우 on 7/10/25.
//

import Foundation

// MARK: - APIClient Protocol

protocol APIClientInterface {
    func request<T: Decodable>(
        path: String,
        method: HTTPMethod,
        headers: [String: String],
        queryItems: [URLQueryItem]?,
        body: Encodable?
    ) async throws -> ResponseDTO<T>
}
