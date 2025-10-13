//
//  LoginViewModel.swift
//  DDOBAK
//
//  Created by 이건우 on 10/12/25.
//

import Observation
import AuthenticationServices

@Observable
final class LoginViewModel {
    
    private let authTokenStore: AuthTokenStoreable = KeyChainTokenStore.init()
    
    @ObservationIgnored let onboardingContent: [OnboardingContent] = OnboardingContent.generate()
    var currentOnboardingImageIndex: Int = .zero
    
    @ObservationIgnored var alertTitle = ""
    @ObservationIgnored var alertMessage = ""
    var showAlert = false
    
    /// success flags
    var isNewUser: Bool = false
    var loginSuccess: Bool = false
    
    func configureAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]

        // request.nonce = ...
        // request.state = ...
    }

    func handleAppleCompletion(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
                
                let _ = credential.user
                let _ = credential.fullName
                let _ = credential.email

                // Identity token(JWT)
                guard let token = credential.identityToken.flatMap({ String(data: $0, encoding: .utf8) }) else {
                    showErrorAlert(alertMessage: "인증 토큰을 가져오지 못했습니다.\n 잠시 후 다시 시도해주세요.")
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
    
    func requestAppleSignIn(identityToken: String) async {
        do {
            let identityToken = ["identityToken": identityToken]
            let appleLoginResponse: ResponseDTO<AppleLoginResponse> = try await APIClient.shared.request(
                path: "/auth/apple/login",
                method: .post,
                body: identityToken
            )
            
            if let data = appleLoginResponse.data {
                /// `accessToken`, `refreshToken` 저장
                authTokenStore.accessToken = data.accessToken
                authTokenStore.refreshToken = data.refreshToken
                
                self.isNewUser = data.newUser
                self.loginSuccess = appleLoginResponse.success
            }
            
        } catch {
            showErrorAlert(alertMessage: error.localizedDescription)
        }
    }
    
    func showErrorAlert(alertMessage: String) {
        self.alertTitle = "로그인 실패"
        self.alertMessage = alertMessage
        self.showAlert = true
    }
}
