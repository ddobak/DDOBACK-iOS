//
//  HowToUseView.swift
//  DDOBAK
//
//  Created by 이건우 on 7/14/25.
//

import SwiftUI

struct HowToUseView: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    private let urlPath: String = "/guide"
    
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
            
            DdobakWebView(path: urlPath)
                .padding(.top, TopNavigationBarAppearance.topNavigationBarHeight + safeAreaInsets.top)
                .ignoresSafeArea(.all)
        }
        .background(.mainWhite)
    }
}
