//
//  AnalysisFailView.swift
//  DDOBAK
//
//  Created by 이건우 on 10/2/25.
//

import SwiftUI

struct AnalysisFailView: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    
    private let analysisFailImageName: String = "analysisFail"
    private let failText: String = "흠...\n이건 조금 어려운 문서네요!"
    private let failSubText: String = "또박이가 분석에 실패했어요...\n계약서가 아닌 사진을 업로드하지는 않았는지 확인해주세요!"
    private let buttonText: String = "사진 다시 올리기"
    
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
            .onTrailingItemTap {
                navigationModel.pop()
            }
            .zIndex(1)
            
            Spacer()
            
            Image(analysisFailImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 20)
            
            DdobakPageTitle(
                viewData: .init(
                    title: failText,
                    subtitleType: .normal(failSubText),
                    alignment: .center
                )
            )
            
            Spacer()
            
            DdobakButton(
                viewData: .init(
                    title: buttonText,
                    buttonType: .primary,
                    isEnabled: true,
                    isLoading: false
                )
            )
            .onButtonTap {
                navigationModel.pop()
                navigationModel.push(.selectContractType)
            }
            .padding(.bottom, 22)
        }
        .containerRelativeFrame([.horizontal, .vertical])
        .background(.mainWhite)
    }
}

#Preview {
    AnalysisFailView()
}
