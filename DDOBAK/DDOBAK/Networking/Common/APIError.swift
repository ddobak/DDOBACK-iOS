//
//  APIError.swift
//  DDOBAK
//
//  Created by 이건우 on 7/10/25.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decoding(Error)
    case refreshFailed
    case unauthorized
    case multipartEncodingFailed
    case unknown(Error)

    public var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .invalidResponse: return "Invalid response."
        case .statusCode(let code): return "Unexpected status code: \(code)"
        case .decoding(let err): return "Decoding failed: \(decodingErrorDescription(err))"
        case .refreshFailed: return "Token refresh failed."
        case .unauthorized: return "Unauthorized."
        case .multipartEncodingFailed: return "Multipart encoding failed."
        case .unknown(let err): return "Unknown error: \(err)"
        }
    }

    private func decodingErrorDescription(_ error: Error) -> String {
        if let decodingError = error as? DecodingError {
            switch decodingError {
            case .typeMismatch(let type, let context):
                return "Type mismatch for type '\(type)' at path '\(context.codingPathString)': \(context.debugDescription)"
            case .valueNotFound(let type, let context):
                return "Value not found for type '\(type)' at path '\(context.codingPathString)': \(context.debugDescription)"
            case .keyNotFound(let key, let context):
                return "Key '\(key.stringValue)' not found at path '\(context.codingPathString)': \(context.debugDescription)"
            case .dataCorrupted(let context):
                return "Data corrupted at path '\(context.codingPathString)': \(context.debugDescription)"
            @unknown default:
                return "Unknown decoding error: \(error.localizedDescription)"
            }
        }
        return error.localizedDescription
    }
}

// MARK: - Helper extension for CodingPath
private extension DecodingError.Context {
    var codingPathString: String {
        codingPath.map { $0.stringValue }.joined(separator: ".")
    }
}
