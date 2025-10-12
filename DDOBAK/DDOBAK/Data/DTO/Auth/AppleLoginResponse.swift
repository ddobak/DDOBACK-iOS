//
//  AppleLoginResponse.swift
//  DDOBAK
//
//  Created by 이건우 on 10/12/25.
//

import Foundation

/// Apple 로그인 응답값
struct AppleLoginResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    let userId: Int
    let newUser: Bool
}
