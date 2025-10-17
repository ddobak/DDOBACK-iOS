//
//  CheckOCRResultView.swift
//  DDOBAK
//
//  Created by 이건우 on 6/22/25.
//

import SwiftUI

struct CheckOCRResultView: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @State private var webViewHandler: DdobakWebViewEventHandler = .init()
    
    private let basePath: String = "/ocr?contId="
    private let contractId: String
    
    init(contractId: String) {
        self.contractId = contractId
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
            
            DdobakWebView(path: basePath + contractId, listener: webViewHandler)
                .padding(.top, TopNavigationBarAppearance.topNavigationBarHeight + safeAreaInsets.top)
                .ignoresSafeArea(.all)
        }
        .background(.mainWhite)
        .onChange(of: webViewHandler.popToRoot) { _, shouldPopToRoot in
            if shouldPopToRoot { navigationModel.popToRoot() }
        }
    }
}
