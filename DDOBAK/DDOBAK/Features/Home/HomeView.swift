//
//  HomeView.swift
//  DDOBAK
//
//  Created by 이건우 on 7/5/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(NavigationModel.self) private var navigationModel
    
    var body: some View {
        VStack(spacing: .zero) {
            TopNavigationBar(
                viewData: .init(
                    shouldShowleadingItem: true,
                    leadingItem: .logo,
                    shouldShowNavigationTitle: false,
                    navigationTitle: nil,
                    shouldShowTrailingItem: true,
                    trailingItem: .icon(type: .myPage)
                )
            )
            
            Spacer()
        }
    }
}

extension HomeView {
        
//    private var noticeBanner: some View {
//        
//    }
}

#Preview {
    HomeView()
        .environment(NavigationModel())
}
