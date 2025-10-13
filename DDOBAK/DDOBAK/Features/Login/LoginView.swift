//
//  LoginView.swift
//  DDOBAK
//
//  Created by 이건우 on 9/18/25.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    
    @State private var viewModel: LoginViewModel = .init()
    
    var body: some View {
        let contents = viewModel.onboardingContent
        
        VStack(spacing: .zero) {
            
            /// 상단 온보딩 탭뷰
            TabView(selection: $viewModel.currentOnboardingImageIndex) {
                ForEach(contents.indices, id: \.self) { index in
                    Image(contents[index].imageName)
                        .resizable()
                        .scaledToFill()
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            
            /// 설명 글
            Text(contents[viewModel.currentOnboardingImageIndex].description)
                .multilineTextAlignment(.center)
                .padding(.top, 30)
                .padding(.bottom, 25)
            
            /// 페이지 인디케이터
            TabViewPageIndicator(
                contentCount: contents.count,
                selectedIndex: viewModel.currentOnboardingImageIndex
            )
            .frame(height: 8)
            
            Spacer()
                .frame(height: 70)
            
            /// 애플 로그인 버튼
            SignInWithAppleButton(
                .signIn,
                onRequest: viewModel.configureAppleRequest,
                onCompletion: viewModel.handleAppleCompletion
            )
            .signInWithAppleButtonStyle(.black)
            .frame(height: 52)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 20)
            .padding(.bottom, 38)
        }
        .background(.mainWhite)
        .animation(.easeInOut, value: viewModel.currentOnboardingImageIndex)
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
        .onChange(of: viewModel.loginSuccess) { _, newValue in
            if viewModel.isNewUser == true {
                /// 신규 유저일 경우, 닉네임 입력 및 유저 생성 수행
                navigationModel.push(.userInfoSetup)
            } else {
                /// Login State 변경으로 Home으로 화면 전환됨.
                withAnimation {
                    LoginStateStore.shared.update(isLoggedIn: true, userIdentifier: nil)
                }
            }
        }
    }
}

fileprivate struct TabViewPageIndicator: View {
    
    private var contentCount: Int
    private var selectedIndex: Int
    
    fileprivate init(
        contentCount: Int,
        selectedIndex: Int
    ) {
        self.contentCount = contentCount
        self.selectedIndex = selectedIndex
    }
    
    fileprivate var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<contentCount, id: \.self) { index in
                Capsule()
                    .fill(selectedIndex == index ? Color.mainBlue : Color.gray3)
                    .frame(
                        width: selectedIndex == index ? 20 : 8,
                        height: 8
                    )
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}


#Preview {
    LoginView()
        .environment(NavigationModel())
}
