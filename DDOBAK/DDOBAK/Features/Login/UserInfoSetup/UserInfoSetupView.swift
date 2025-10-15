//
//  UserInfoSetupView.swift
//  DDOBAK
//
//  Created by 이건우 on 10/13/25.
//

import SwiftUI

struct UserInfoSetupView: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    @State private var viewModel: UserInfoSetupViewViewModel = .init()
    
    private let isEditing: Bool
    
    init(isEditing: Bool) {
        self.isEditing = isEditing
    }
    
    private var pageTitle: String {
        isEditing
        ? "또박이가 부를\n새 이름을 입력해주세요"
        : "또박이가 부를\n이름을 입력해주세요"
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            DdobakPageTitle(
                viewData: .init(
                    title: pageTitle,
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
        }
    }
}

private extension UserInfoSetupView {
    
    private var confirmButtonWithSkipView: some View {
        VStack(spacing: 20) {
            
            /// `건너뛰기` 신규 가입 시에만 노출
            if isEditing == false {
                Button {
                    Task { @MainActor in
                        let success = await viewModel.createUser(isSkipping: true)
                        navigationModel.popToRoot()
                        if success {
                            withAnimation { LoginStateStore.shared.update(isLoggedIn: true, userIdentifier: nil) }
                        }
                    }
                } label: {
                    Text("건너뛰기")
                        .font(.ddobak(.caption1_m16))
                        .foregroundStyle(.gray5)
                }
            }
            
            DdobakButton(
                viewData: .init(
                    title: "다음",
                    buttonType: .primary,
                    isEnabled: viewModel.isValid && viewModel.isLoading == false,
                    isLoading: false
                )
            )
            .onButtonTap {
                Task { @MainActor in
                    endEditing()
                    
                    switch isEditing {
                    case true:
                        /// `userInfo` 변경 성공 시 `pop` 처리
                        let success = await viewModel.editUser()
                        if success { navigationModel.popToRoot() }
                        
                    case false:
                        /// 회원가입 후 `home`으로 화면 전환
                        let success = await viewModel.createUser()
                        navigationModel.popToRoot()
                        if success {
                            withAnimation { LoginStateStore.shared.update(isLoggedIn: true, userIdentifier: nil) }
                        }
                    }
                }
            }
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    UserInfoSetupView(isEditing: true)
}
