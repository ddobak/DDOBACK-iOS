//
//  HoneyTipView.swift
//  DDOBAK
//
//  Created by 이건우 on 7/14/25.
//

import SwiftUI

struct HoneyTipView: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    private let basePath: String = "/tips/"
    private let tipId: String
    
    init(tipId: String) {
        self.tipId = tipId
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
            
            DdobakWebView(path: basePath + tipId)
                .padding(.top, TopNavigationBarAppearance.topNavigationBarHeight + safeAreaInsets.top)
                .ignoresSafeArea(.all)
        }
        .background(.mainWhite)
    }
}
