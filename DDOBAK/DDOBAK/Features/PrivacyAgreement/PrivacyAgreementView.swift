//
//  PrivacyAgreementView.swift
//  DDOBAK
//
//  Created by 이건우 on 7/6/25.
//

import SwiftUI

struct PrivacyAgreementView: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    private let viewModel: PrivacyAgreementViewModel = .init()
    
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
            
            ScrollView(.vertical) {
                VStack(spacing: .zero) {
                    
                    DdobakPageTitle(
                        viewData: .init(
                            title: "개인정보 수집 및 이용 동의",
                            subtitleType: .normal("분석을 시작하시기 전에, 다음 내용을 꼭 확인해주세요."),
                            alignment: .leading
                        )
                    )
                    .padding(.vertical, 36)
                    
                    agreementItems
                        .padding(.bottom, 25)
                    
                    bottomButtonWithDdobak
                        .padding(.bottom, 22)
                }
            }
            .padding(.top, TopNavigationBarAppearance.topNavigationBarHeight)
            .background(.mainWhite)
        }
    }
}

extension PrivacyAgreementView {
    
    private var agreementItems: some View {
        VStack(spacing: 9) {
            ForEach(viewModel.privacyAgreementData, id: \.self) { data in
                AgreementItemView(agreementData: data)
            }
        }
    }
    
    private var bottomButtonWithDdobak: some View {
        VStack(spacing: .zero) {
            Image("ddobakSecurity")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 20)
            
            DdobakButton(
                viewData: .init(
                    title: "동의하기",
                    buttonType: .primary,
                    isEnabled: true,
                    isLoading: false
                )
            )
        }
    }
}

fileprivate struct AgreementItemView: View {
    
    private let agreementData: PrivacyAgreementViewModel.PrivacyAgreementData
    
    init(agreementData: PrivacyAgreementViewModel.PrivacyAgreementData) {
        self.agreementData = agreementData
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image("pin")
                
                Text(agreementData.title)
                    .font(.ddobak(.body2_b14))
                    .foregroundStyle(.mainBlack)
                
            }
            
            Text(agreementData.content)
                .font(.ddobak(.caption2_m12))
                .foregroundStyle(.mainBlack)
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 17)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.gray1)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    PrivacyAgreementView()
        .environment(NavigationModel())
}
