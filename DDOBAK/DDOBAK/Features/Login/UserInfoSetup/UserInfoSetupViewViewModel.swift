//
//  UserInfoSetupViewViewModel.swift
//  DDOBAK
//
//  Created by 이건우 on 10/13/25.
//

import SwiftUI
import Alamofire

@Observable
final class UserInfoSetupViewViewModel {
    var userName: String = ""
    var isLoading: Bool = false

    var isValid: Bool {
        /// 길이 체크 (2~8자)
        let count = userName.count
        guard count >= 2 && count <= 8 else { return false }

        /// 공백/개행 체크
        if userName.contains(where: { $0.isWhitespace }) { return false }

        /// 모든 문자가 한글 완성형인지 체크 (가~힣)
        for scalar in userName.unicodeScalars {
            if !(scalar.value >= 0xAC00 && scalar.value <= 0xD7A3) {
                return false
            }
        }
        return true
    }
    
    func createUser(isSkipping: Bool = false) async -> (Bool, String) {
        isLoading = true
        defer { isLoading = false }
        
        do {
            /// 건너뛰기 시 `김또박`으로 설정
            let name: String = isSkipping ? "김또박" : userName
            let createUserResponse: ResponseDTO<Empty> = try await APIClient.shared.request(
                path: "/user/profile",
                method: .post,
                body: ["name": name]
            )
            return (createUserResponse.success, name)
        } catch {
            return (false, "")
        }
    }
    
    func editUser() async -> Bool {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let editUserResponse: ResponseDTO<UserInfo> = try await APIClient.shared.request(
                path: "/user/profile",
                method: .put,
                body: ["name": userName]
            )
            return editUserResponse.success
            
        } catch {
            return false
        }
    }
}
