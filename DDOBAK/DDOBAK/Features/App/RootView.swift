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
                        case .selectDocumetType:
                            SelectContractTypeView()
                            
                        case .privacyAgreement:
                            PrivacyAgreementView()
                            
                        case .selectDocumetUploadMethod:
                            SelectContractUploadMethodView()
                            
                        case .checkOcrResult(let contractId):
                            CheckOCRResultView(contractId: contractId)
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
