//
//  UserInfo.swift
//  DDOBAK
//
//  Created by 이건우 on 10/13/25.
//

import Foundation

/// 유저 정보 DTO (추후 생년월일 및 직업 등 추가 가능)
struct UserInfo: Decodable {
    let name: String
}
