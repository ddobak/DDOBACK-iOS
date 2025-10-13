//
//  MyPageView.swift
//  DDOBAK
//
//  Created by 이건우 on 10/13/25.
//

import SwiftUI

struct MyPageView: View {
    var body: some View {
        VStack(spacing: .zero) {
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
            
            profileView
            
            Rectangle()
                .frame(height: 8)
                .foregroundStyle(.gray2)
            
            DdobakSectionHeader(
                title: "기본 정보",
                titleColor: .mainBlack
            )
            .padding(.top, 30)

            Spacer()
        }
        .background(.mainWhite)
    }
}

private extension MyPageView {
    
    @ViewBuilder
    private var profileView: some View {
        Spacer()
            .frame(height: 36)
        
        Image("kimddobak")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(.horizontal, 140)
        
        Spacer()
            .frame(height: 20)
        
        Text("김또박")
            .font(.ddobak(.title3_sb20))
            .foregroundStyle(.mainBlack)
        
        Spacer()
            .frame(height: 36)
    }
}

#Preview {
    MyPageView()
}
