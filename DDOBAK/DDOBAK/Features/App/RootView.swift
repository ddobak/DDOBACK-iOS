//
//  RootView.swift
//  DDOBAK
//
//  Created by 이건우 on 6/21/25.
//

import SwiftUI

struct RootView: View {
    
    @State private var navigationModel: NavigationModel = .init()
    @State private var contractAnalysisFlowModel: ContractAnalysisFlowModel = .init()
    
    var body: some View {
        homeView
    }
}

private extension RootView {
    
    @ViewBuilder
    var homeView: some View {
        @Bindable var navigationModel = navigationModel
        @Bindable var contractAnalysisFlowModel = contractAnalysisFlowModel
        
        NavigationStack(path: $navigationModel.path) {
            HomeView()
                .navigationDestination(for: NavigationModel.NavigationDestination.self) { destination in
                    Group {
                        switch destination {
                        case .selectContractType:
                            SelectContractTypeView()
                            
                        case .privacyAgreement:
                            PrivacyAgreementView()
                            
                        case .selectContractUploadMethod:
                            SelectContractUploadMethodView()
                            
                        case .checkOcrResult(let contractId):
                            CheckOCRResultView(contractId: contractId)
                            
                        case .analysisResult(let contractId, let analysisId):
                            AnalysisResultView(contractId: contractId, analysisId: analysisId)
                            
                        case .howToUse:
                            HowToUseView()
                            
                        case .honeyTip(let tipId):
                            HoneyTipView(tipId: tipId)
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                }
        }
        .environment(navigationModel)
        .environment(contractAnalysisFlowModel)
    }
}

#Preview {
    RootView()
        .environment(NavigationModel())
}
