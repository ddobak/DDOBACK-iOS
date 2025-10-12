//
//  DefaultTokenStore.swift
//  DDOBAK
//
//  Created by 이건우 on 12/10/25.
//

import Foundation

// MARK: - TokenStore Protocol
protocol TokenStore: AnyObject {
    func accessToken() -> String?
    func refreshToken() -> String?
    func updateTokens(accessToken: String?, refreshToken: String?)
    func clear()
}

// MARK: - DefaultTokenStore
/// Simple UserDefaults-backed token store.
/// In production, consider using Keychain for security.
final class DefaultTokenStore: TokenStore {
    private let accessKey: String
    private let refreshKey: String
    private let userDefaults: UserDefaults
    private let lock = NSLock()

    init(
        accessKey: String = "accessToken",
        refreshKey: String = "refreshToken",
        userDefaults: UserDefaults = .standard
    ) {
        self.accessKey = accessKey
        self.refreshKey = refreshKey
        self.userDefaults = userDefaults
    }

    func accessToken() -> String? {
        lock.lock(); defer { lock.unlock() }
        return userDefaults.string(forKey: accessKey)
    }

    func refreshToken() -> String? {
        lock.lock(); defer { lock.unlock() }
        return userDefaults.string(forKey: refreshKey)
    }

    func updateTokens(accessToken: String?, refreshToken: String?) {
        lock.lock(); defer { lock.unlock() }
        if let accessToken = accessToken {
            userDefaults.set(accessToken, forKey: accessKey)
        }
        if let refreshToken = refreshToken {
            userDefaults.set(refreshToken, forKey: refreshKey)
        }
    }

    func clear() {
        lock.lock(); defer { lock.unlock() }
        userDefaults.removeObject(forKey: accessKey)
        userDefaults.removeObject(forKey: refreshKey)
    }
}
