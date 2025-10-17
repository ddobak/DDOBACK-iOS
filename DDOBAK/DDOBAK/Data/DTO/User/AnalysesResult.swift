//
//  AnalysesResult.swift
//  DDOBAK
//
//  Created by 이건우 on 7/10/25.
//

import Foundation

/// 분석 결과 계약서 목록 DTO
struct AnalysesResult: Decodable {
    let contractsCount: Int
    let contracts: [Contract]
}
