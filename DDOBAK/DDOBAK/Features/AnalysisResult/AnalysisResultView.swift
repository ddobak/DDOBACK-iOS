//
//  AnalysisResultView.swift
//  DDOBAK
//
//  Created by 이건우 on 6/22/25.
//

import SwiftUI

struct AnalysisResultView: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @State private var webViewHandler: DdobakWebViewEventHandler = .init()
    
    private let contractId: String
    private let analysisId: String
    
    init(
        contractId: String,
        analysisId: String
    ) {
        self.contractId = contractId
        self.analysisId = analysisId
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            TopNavigationBar(
                viewData: .init(
                    shouldShowleadingItem: true,
                    leadingItem: .backButton,
                    shouldShowNavigationTitle: false,
                    navigationTitle: nil,
                    shouldShowTrailingItem: false,
                    trailingItem: .none
                )
            )
            .setAppearance(.light)
            .onLeadingItemTap {
                navigationModel.pop()
            }
            .zIndex(1)
            
            DdobakWebView(path: buildPath(), listener: webViewHandler)
                .padding(.top, TopNavigationBarAppearance.topNavigationBarHeight + safeAreaInsets.top)
                .ignoresSafeArea(.all)
        }
        .background(.mainWhite)
        .onChange(of: webViewHandler.popToRoot) { _, popToRoot in
            if popToRoot {
                navigationModel.popToRoot()
            }
        }
        .onChange(of: webViewHandler.analyzeOtherContract) { _, analyzeOtherContract in
            if analyzeOtherContract {
                navigationModel.popToRoot()
                navigationModel.push(.selectContractType)
            }
        }
        .sheet(isPresented: $webViewHandler.showActivityView) {
            if let activityFileURL = webViewHandler.activityFileURL {
                ActivityView(activityItems: [activityFileURL])
            }
        }
    }
    
    private func buildPath() -> String {
        return "/analysis?contId=\(contractId)&analysisId=\(analysisId)"
    }
}

