//
//  SelectDocumentTypeView.swift
//  DDOBAK
//
//  Created by 이건우 on 7/6/25.
//

import SwiftUI

struct SelectDocumentTypeView: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    @StateObject private var viewModel: SelectDocumentTypeViewModel = .init()
    
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
                    isEnabled: viewModel.selectedDocumentType != .none,
                    isLoading: false
                )
            )
            .onButtonTap {
                navigationModel.push(.privacyAgreement)
            }
            .padding(.bottom, 22)
        }
        .background(.mainWhite)
    }
}

extension SelectDocumentTypeView {
    var selectButtons: some View {
        VStack(spacing: 12) {
            ForEach(SelectDocumentTypeViewModel.DocumentType.allCases.filter { $0 != .none }, id: \.self) { type in
                Button {
                    viewModel.selectedDocumentType = type
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: selectButtonHeight)
                        .foregroundStyle(
                            viewModel.selectedDocumentType == type
                            ? .lightBlue
                            : .gray2
                        )
                        .overlay {
                            Text(type.rawValue)
                                .foregroundStyle(.mainBlack)
                        }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    SelectDocumentTypeView()
        .environment(NavigationModel())
}
