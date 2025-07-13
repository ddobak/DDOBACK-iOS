//
//  ContractAnalysisFlowModel.swift
//  DDOBAK
//
//  Created by 이건우 on 7/13/25.
//

import SwiftUI

/// 계약서 분석 플로우에서 선택된 계약서 종류 `contractType`을 관리하는 객체
@Observable
final class ContractAnalysisFlowModel {
    var selectedContractType: ContractType?
}
