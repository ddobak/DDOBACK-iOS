//
//  APIError.swift
//  DDOBAK
//
//  Created by 이건우 on 7/10/25.
//

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decoding(Error)
}
