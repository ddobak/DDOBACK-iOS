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
        
        /// 로그인
        case userInfoSetup
        
        /// 유저
        case myPage
        
        /// 분석
        case selectContractType
        case privacyAgreement
        case selectContractUploadMethod
        case checkOcrResult(contractId: String)
        
        /// 아카이브 열람
        case archiveList

        /// 분석 결과
        case analysisStatus(analysisStatus: Contract.AnalysisStatus, contractData: Contract)
        case analysisResult(contractId: String, analysisId: String)
        
        /// 이용 가이드
        case howToUse
        
        /// 꿀팁
        case honeyTip(tipId: String)
    }
}
