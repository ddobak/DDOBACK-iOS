//
//  ResponseDTO.swift
//  DDOBAK
//
//  Created by 이건우 on 7/10/25.
//

import Foundation

// MARK: - API Response

struct ResponseDTO<T: Decodable>: Decodable {
    let success: Bool
    let code: Int
    let message: String
    let userMessage: String?
    let data: T?
    let timestamp: String
    let traceId: String
}
