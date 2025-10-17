//
//  AnalysisSuccessView.swift
//  DDOBAK
//
//  Created by 이건우 on 10/2/25.
//

import SwiftUI

struct AnalysisSuccessView: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    
    private let toxicClauseCount: Int
    private let contractId: String
    private let analysisId: String
    
    private let tagAttributeString: AttributedString
    
    private let analysisSuccessImageName: String = "analysisSuccess"
    private let successText: String = "또박또박 다 읽었어요!"
    private let successSubText: String = "주의가 필요한 조항이 보여요!\n또박이의 리포트로 확인해볼까요?"
    private let buttonText: String = "또박이 리포트보기"
    
    init(
        toxicClauseCount: Int,
        contractId: String,
        analysisId: String
    ) {
        self.toxicClauseCount = toxicClauseCount
        self.contractId = contractId
        self.analysisId = analysisId
        
        tagAttributeString = .makeAttributedString(text: "독소 조항 발견 개수 : \(toxicClauseCount)개",
                                                   boldText: ["\(toxicClauseCount)개"],
                                                   baseFont: .body2_m14)
    }
    
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
            
            Image(analysisSuccessImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 20)
            
            DdobakPageTitle(
                viewData: .init(
                    title: successText,
                    subtitleType: .normal(successSubText),
                    alignment: .center
                )
            )
            .padding(.bottom, 20)
            
            DdobakTag(
                viewData: .init(
                    title: tagAttributeString,
                    titleColor: .mainBlue,
                    backgroundColor: .lightBlue,
                    borderColor: .mainBlue
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
                navigationModel.push(.analysisResult(contractId: contractId, analysisId: analysisId))
            }
            .padding(.bottom, 22)
        }
        .containerRelativeFrame([.horizontal, .vertical])
        .background(.mainWhite)
    }
}

#Preview {
    AnalysisSuccessView(toxicClauseCount: 3, contractId: "1", analysisId: "1")
}
