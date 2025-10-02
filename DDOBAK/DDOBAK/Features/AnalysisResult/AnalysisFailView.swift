//
//  AnalysisFailView.swift
//  DDOBAK
//
//  Created by 이건우 on 10/2/25.
//

import SwiftUI

struct AnalysisFailView: View {
    var body: some View {
        VStack {
            TopNavigationBar(
                viewData: .init(
                    shouldShowleadingItem: false,
                    leadingItem: .none,
                    shouldShowNavigationTitle: false,
                    navigationTitle: nil,
                    shouldShowTrailingItem: true,
                    trailingItem: .icon(type: .xmark)
                )
            )
            .setAppearance(.light)
            
            
            Spacer()
            
            // image
            
            Spacer()
            
            DdobakButton(
                viewData: .init(
                    title: "사진 다시 올리기",
                    buttonType: .primary,
                    isEnabled: true,
                    isLoading: false
                )
            )
            .padding(.bottom, 22)
        }
        .containerRelativeFrame([.horizontal, .vertical])
        .background(.mainWhite)
    }
}

#Preview {
    AnalysisFailView()
}
