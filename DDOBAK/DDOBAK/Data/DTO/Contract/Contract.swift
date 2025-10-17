//
//  Contract.swift
//  DDOBAK
//
//  Created by 이건우 on 7/10/25.
//

/// 계약서 관련 정보 DTO
struct Contract: Decodable, Identifiable, Hashable {
    
    enum AnalysisStatus: String, Decodable {
        case inProgress = "in_progress"
        case completed
        case failed
    }
    
    enum ContractType: String, Decodable {
        case employment
        case rental
        
        var displayName: String {
            switch self {
            case .employment: "근로계약서"
            case .rental: "임대차계약서"
            }
        }
    }
    
    var id: String { contractId }

    let contractId: String
    let contractTitle: String
    let contractType: ContractType
    let analysisStatus: AnalysisStatus
    let analysisId: String
    let toxicCounts: Int
    let analysisDate: String

    private enum CodingKeys: String, CodingKey {
        case contractId, contractTitle, contractType
        case analysisStatus, analysisId, toxicCounts, analysisDate
    }
}

extension Contract {
    static func mock() -> Contract {
        .init(
            contractId: "1234567890",
            contractTitle: "서울시 강남구 소재 원룸 임대차 계약서",
            contractType: .employment,
            analysisStatus: .inProgress,
            analysisId: "1234567890",
            toxicCounts: 0,
            analysisDate: "2025-01-01"
        )
    }
}
