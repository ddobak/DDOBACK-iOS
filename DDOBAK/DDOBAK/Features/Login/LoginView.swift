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
    
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack {
            SignInWithAppleButton(
                .signIn,
                onRequest: configureAppleRequest(_:),
                onCompletion: handleAppleCompletion(result:)
            )
            .signInWithAppleButtonStyle(.black)
            .frame(height: 52)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
        .alert("애플 로그인 오류", isPresented: $showAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    // MARK: - Apple Sign In

    private func configureAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]

        // request.nonce = ...
        // request.state = ...
    }

    private func handleAppleCompletion(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
                
                let _ = credential.user
                let _ = credential.fullName
                let _ = credential.email

                // Identity token(JWT)
                guard let token = credential.identityToken.flatMap({ String(data: $0, encoding: .utf8) }) else {
                    alertMessage = "인증 토큰을 가져오지 못했습니다. 잠시 후 다시 시도해주세요."
                    showAlert = true
                    return
                }

                // Apple Sign In 요청
                DDOBakLogger.log("Apple Sign In Success", level: .info, category: .network)
                Task {
                    await requestAppleSignIn(identityToken: token)
                }
            }
            
        case .failure(let error):
            DDOBakLogger.log("Apple Sign In Failed: \(error)", level: .error, category: .network)
        }
    }
    
    private func requestAppleSignIn(identityToken: String) async {
        do {
            let identityToken = ["identityToken": identityToken]
            let appleLoginResponse: ResponseDTO<AppleLoginResponse> = try await APIClient.shared.request(
                path: "/api/auth/apple/login",
                method: .post,
                body: identityToken
            )
            
            if let data = appleLoginResponse.data {
                let isRequestSuccess: Bool = appleLoginResponse.success
                let isNewUser: Bool = data.newUser
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    LoginView()
}
