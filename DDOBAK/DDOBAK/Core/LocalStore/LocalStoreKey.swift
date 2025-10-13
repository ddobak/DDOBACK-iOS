//
//  LocalStoreKey.swift
//  DDOBAK
//
//  Created by 이건우 on 10/1/25.
//

import Foundation

/// local store들에서 사용되는 Key 값들
enum LocalStoreKey: String {
    
    // keychain
    case accessToken
    case refreshToken
    
    // userDefault
    case isLoggedIn
    case userIdentifier
}
