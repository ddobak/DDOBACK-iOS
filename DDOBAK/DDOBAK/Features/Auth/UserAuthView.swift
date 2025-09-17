//
//  UserAuthView.swift
//  DDOBAK
//
//  Created by 이건우 on 9/18/25.
//

import SwiftUI
import AuthenticationServices

struct UserAuthView: View {
    var body: some View {
        VStack {
            SignInWithAppleButton(
                .signIn,
                onRequest: configureAppleRequest(_:),
                onCompletion: handleAppleCompletion(result:)
            )
            .signInWithAppleButtonStyle(.black)
            .frame(height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
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
                // 고유 사용자 식별자
                let userID = credential.user

                // 최초 동의 시에만 제공
                let fullName = credential.fullName
                let email = credential.email

                // Identity token(JWT)
                let identityToken = credential.identityToken.flatMap { String(data: $0, encoding: .utf8) }

                // TODO: 서버 로직
                print("[Apple SignIn Success]")
                print("userID:", userID)
                print("identityToken:", identityToken)
                print("fullName:", fullName?.formatted() ?? "unknown")
                print("email:", email ?? "unknown")
            }
            
        case .failure(let error):
            print("[Apple SignIn Failed]:", error.localizedDescription)
        }
    }
}

#Preview {
    UserAuthView()
}
