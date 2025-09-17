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
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL - 잘못된 URL입니다."

        case .invalidResponse:
            return "Invalid Response - 서버 응답이 올바르지 않습니다."

        case .statusCode(let code):
            return "HTTP Status Code: \(code) - 서버에서 오류 코드가 반환되었습니다."

        case .decoding(let error):
            return "Decoding Error - \(decodingErrorDescription(error))"
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
