//
//  NavigationModel.swift
//  DDOBAK
//
//  Created by 이건우 on 6/21/25.
//

import SwiftUI

@Observable
final class NavigationModel {
    
    var path: [NavigationDestination]
    
    init(path: [NavigationDestination] = []) {
        self.path = path
    }
}

extension NavigationModel {
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func push(_ destination: NavigationDestination) {
        path.append(destination)
    }
    
    func push(contentsOf destinations: [NavigationDestination]) {
        path.append(contentsOf: destinations)
    }
}

extension NavigationModel {
    enum NavigationDestination: Hashable {
        case selectContractType
        case privacyAgreement
        case selectContractUploadMethod
        case checkOcrResult(contractId: String)
        case analysisResult(contractId: String, analysisId: String)
        case honeyTip(tipId: String)
    }
}
