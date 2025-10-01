//
//  KeychainStorage.swift
//  DDOBAK
//
//  Created by 이건우 on 10/1/25.
//

import Foundation

protocol KeychainStorageProtocol {
    func save(token: String, for key: String)
    func read(for key: String) -> String?
    func delete(for key: String)
}

final class KeychainStorage: KeychainStorageProtocol {
    static let shared = KeychainStorage()

    func save(token: String, for key: String) {
        let data = Data(token.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        /// 기존 값 제거
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    func read(for key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &item)
        guard let data = item as? Data,
              let token = String(data: data, encoding: .utf8) else { return nil }
        return token
    }

    func delete(for key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
