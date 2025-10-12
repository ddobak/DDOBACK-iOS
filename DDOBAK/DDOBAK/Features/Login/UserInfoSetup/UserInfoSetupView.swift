//
//  UserInfoSetupView.swift
//  DDOBAK
//
//  Created by 이건우 on 10/13/25.
//

import SwiftUI

struct UserInfoSetupView: View {
    @State private var viewModel: UserInfoSetupViewViewModel = .init()
    
    var body: some View {
        VStack(spacing: .zero) {
            DdobakPageTitle(
                viewData: .init(
                    title: "또박이가 부를\n이름을 입력해주세요",
                    subtitleType: .secondary("한글로 2자 이상 8자 이하로 작성해주세요."),
                    alignment: .leading
                )
            )
            .padding(.top, 78)
            
            Spacer()
                .frame(height: 40)
            
            DdobakTextField(
                placeholder: "이름을 입력해주세요",
                input: $viewModel.userName
            )
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .background(.mainWhite)
        .loadingOverlay(isLoading: $viewModel.isLoading)
        .safeAreaInset(edge: .bottom) {
            DdobakButton(
                viewData: .init(
                    title: "다음",
                    buttonType: .primary,
                    isEnabled: viewModel.isValid && viewModel.isLoading == false,
                    isLoading: false
                )
            )
            .onButtonTap {
                Task {
                    endEditing()
                    await viewModel.createUser()
                }
            }
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    UserInfoSetupView()
}
