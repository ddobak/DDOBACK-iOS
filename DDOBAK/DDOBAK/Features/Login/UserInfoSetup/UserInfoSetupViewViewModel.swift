//
//  UserInfoSetupViewViewModel.swift
//  DDOBAK
//
//  Created by 이건우 on 10/13/25.
//

import Observation

@Observable
final class UserInfoSetupViewViewModel {
    var userName: String = ""

    // 한글만, 8자 이내, 공백 없이
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
}
