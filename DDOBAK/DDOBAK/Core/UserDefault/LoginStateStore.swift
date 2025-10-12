//
//  LoginStateStore.swift
//  DDOBAK
//
//  Created by Assistant on 12/10/25.
//

import Foundation

// MARK: - LoginStateStore Protocol
protocol LoginStateStoreable: AnyObject {
    /// 현재 로그인 여부를 반환합니다. 저장된 값이 없으면 false를 반환합니다.
    func isLoggedIn() -> Bool
    /// 현재 로그인된 사용자 식별자를 반환합니다. (없을 수 있음)
    func userIdentifier() -> String?
    /// 로그인 상태와 사용자 식별자를 갱신합니다.
    /// - Parameters:
    ///   - isLoggedIn: 로그인 여부
    ///   - userIdentifier: 사용자 식별자(선택). nil을 넘기면 기존 값을 변경하지 않습니다.
    func update(isLoggedIn: Bool, userIdentifier: String?)
    /// 저장된 로그인 상태와 사용자 식별자를 모두 제거합니다.
    func clear()
}

// MARK: - DefaultLoginStateStore
/// Simple UserDefaults-backed login state store.
/// In production, consider persisting sensitive identifiers securely (e.g., Keychain).
final class LoginStateStore: LoginStateStoreable {
    private let isLoggedInKey: String
    private let userIdentifierKey: String
    private let userDefaults: UserDefaults
    private let lock = NSLock()

    init(
        isLoggedInKey: String = "isLoggedIn",
        userIdentifierKey: String = "userIdentifier",
        userDefaults: UserDefaults = .standard
    ) {
        self.isLoggedInKey = isLoggedInKey
        self.userIdentifierKey = userIdentifierKey
        self.userDefaults = userDefaults
    }

    func isLoggedIn() -> Bool {
        lock.lock(); defer { lock.unlock() }
        return userDefaults.bool(forKey: isLoggedInKey)
    }

    func userIdentifier() -> String? {
        lock.lock(); defer { lock.unlock() }
        return userDefaults.string(forKey: userIdentifierKey)
    }

    func update(isLoggedIn: Bool, userIdentifier: String?) {
        lock.lock(); defer { lock.unlock() }
        userDefaults.set(isLoggedIn, forKey: isLoggedInKey)
        if let userIdentifier = userIdentifier {
            userDefaults.set(userIdentifier, forKey: userIdentifierKey)
        }
    }

    func clear() {
        lock.lock(); defer { lock.unlock() }
        userDefaults.removeObject(forKey: isLoggedInKey)
        userDefaults.removeObject(forKey: userIdentifierKey)
    }
}
