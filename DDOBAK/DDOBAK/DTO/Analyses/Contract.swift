//
//  Contract.swift
//  DDOBAK
//
//  Created by 이건우 on 7/10/25.
//

/// 계약서 관련 정보 DTO
struct Contract: Decodable, Identifiable, Hashable {
    var id: String { contractId }

    let contractId: String
    let contractTitle: String
    let contractType: String
    let analysisStatus: String
    let analysisId: String
    let toxicCounts: Int
    let analysisDate: String
}
