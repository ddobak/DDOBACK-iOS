//
//  ContractType.swift
//  DDOBAK
//
//  Created by 이건우 on 7/13/25.
//

enum ContractType: String, CaseIterable, Hashable {
    case 근로계약서
    case 임대차계약서
    case none
    
    func thumbnailImageName(selected: Bool) -> String {
        let suffix = selected ? "selected" : "unselected"
        switch self {
        case .근로계약서:
            return "employment_\(suffix)"
        case .임대차계약서:
            return "rental_\(suffix)"
        default:
            return ""
        }
    }
    
    var requestParameter: String {
        switch self {
        case .근로계약서: "EMPLOYMENT"
        case .임대차계약서: "RENTAL"
        default: ""
        }
    }
}
