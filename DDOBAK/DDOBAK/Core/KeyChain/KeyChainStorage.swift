//
//  KeyChainStorage.swift
//  DDOBAK
//
//  Created by 이건우 on 10/1/25.
//

import Foundation
import Security

protocol AuthTokenStore {
    var accessToken: String? { get set }
    var refreshToken: String? { get set }
    func clear()
}

final class KeyChainTokenStore: AuthTokenStore {
    private let accessKey = KeyChainKey.accessToken.rawValue
    private let refreshKey = KeyChainKey.accessToken.rawValue

    var accessToken: String? {
        get { read(for: accessKey) }
        set { save(newValue, for: accessKey) }
    }
    var refreshToken: String? {
        get { read(for: refreshKey) }
        set { save(newValue, for: refreshKey) }
    }

    func clear() {
        delete(for: accessKey)
        delete(for: refreshKey)
    }

    private func save(_ value: String?, for key: String) {
        delete(for: key)
        guard let value = value else { return }
        let data = Data(value.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        SecItemAdd(query as CFDictionary, nil)
    }

    private func read(for key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &item)
        guard let data = item as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    private func delete(for key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
