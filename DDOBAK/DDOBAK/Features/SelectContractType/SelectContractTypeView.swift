//
//  SelectContractTypeView.swift
//  DDOBAK
//
//  Created by 이건우 on 7/6/25.
//

import SwiftUI

struct SelectContractTypeView: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    @Environment(ContractAnalysisFlowModel.self) private var contractAnalysisFlowModel
    
    @StateObject private var viewModel: SelectContractTypeViewModel = .init()
    
    private let selectButtonHeight: CGFloat = 130
    
    var body: some View {
        VStack(spacing: .zero) {
            TopNavigationBar(
                viewData: .init(
                    shouldShowleadingItem: true,
                    leadingItem: .backButton,
                    shouldShowNavigationTitle: false,
                    navigationTitle: nil,
                    shouldShowTrailingItem: false,
                    trailingItem: nil
                )
            )
            .setAppearance(.light)
            .onLeadingItemTap {
                navigationModel.pop()
            }
            
            DdobakPageTitle(
                viewData: .init(
                    title: "또박이가 분석할\n계약서 종류를 선택해주세요!",
                    subtitleType: .secondary("추후에 다른 종류의 계약서 분석도 제공할 예정입니다."),
                    alignment: .leading
                )
            )
            .padding(.vertical, 36)
            
            Spacer()
                .frame(height: 20)
            
            selectButtons
            
            Spacer()
            
            DdobakButton(
                viewData: .init(
                    title: "다음",
                    buttonType: .primary,
                    isEnabled: viewModel.selectedContractType != .none,
                    isLoading: false
                )
            )
            .onButtonTap {
                contractAnalysisFlowModel.selectedContractType = viewModel.selectedContractType
                navigationModel.push(.privacyAgreement)
            }
            .padding(.bottom, 22)
        }
        .background(.mainWhite)
    }
}

extension SelectContractTypeView {
    var selectButtons: some View {
        VStack(spacing: 12) {
            ForEach(ContractType.allCases.filter { $0 != .none }, id: \.self) { type in
                Button {
                    viewModel.selectedContractType = type
                } label: {
                    Image(type.thumbnailImageName(selected: viewModel.selectedContractType == type))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: selectButtonHeight)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    SelectContractTypeView()
        .environment(NavigationModel())
        .environment(ContractAnalysisFlowModel())
}
