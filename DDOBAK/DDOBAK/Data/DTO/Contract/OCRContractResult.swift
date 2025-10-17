//
//  OCRContractResult.swift
//  DDOBAK
//
//  Created by 이건우 on 7/13/25.
//

import Foundation

/// OCR된 계약서 응답 DTO
struct OCRContractResult: Decodable {
    let contractId: String
    let ocrStatus: String
}
