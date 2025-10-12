//
//  NavigationModel.swift
//  DDOBAK
//
//  Created by 이건우 on 6/21/25.
//

import Observation

@Observable
final class NavigationModel {
    
    var path: [NavigationDestination]
    
    init(path: [NavigationDestination] = []) {
        self.path = path
    }
}

extension NavigationModel {
    
    func replaceRoot(with destination: NavigationDestination) {
        path = [destination]
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    /// 단일 뷰 push
    func push(_ destination: NavigationDestination) {
        path.append(destination)
    }
    
    /// 여러 뷰 push
    func push(contentsOf destinations: [NavigationDestination]) {
        path.append(contentsOf: destinations)
    }
}

extension NavigationModel {
    enum NavigationDestination: Hashable {
        case selectContractType
        case privacyAgreement
        case selectContractUploadMethod
        case archiveList
        case checkOcrResult(contractId: String)
        case analysisStatus(analysisStatus: Contract.AnalysisStatus, contractData: Contract)
        case analysisResult(contractId: String, analysisId: String)
        case howToUse
        case honeyTip(tipId: String)
    }
}
