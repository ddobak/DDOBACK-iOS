//
//  MyPageViewModel.swift
//  DDOBAK
//
//  Created by 이건우 on 10/13/25.
//

import SwiftUI
import Alamofire

@Observable
final class MyPageViewModel {
    
    /// 업데이트 가능 여부
    var isUpdateAvailable: Bool = false
    
    /// 사용자명
    var userName: String?
    var isLoading: Bool = false

    @ObservationIgnored
    var appVersion: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
        if let version = version, let _ = build { /// 빌드 번호는 필요 시 사옹
            return "\(version)"
        }
        return version ?? "—"
    }
    
    @ObservationIgnored
    private let keyChainStore = KeyChainTokenStore()
    @ObservationIgnored
    private let loginStateStore = LoginStateStore()
    
    /// 로그아웃
    func logout() {
        withAnimation {
            keyChainStore.clear()
            loginStateStore.clear()
        }
    }
    
    /// 회원탈퇴
    func resign() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let _: ResponseDTO<Empty> = try await APIClient.shared.request(
                path: "/user/withdraw",
                method: .delete
            )
        } catch {
            
        }
    }
    
    /// 유저 정보 fetch
    func fetchUserInfo() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let userInfoResponse: ResponseDTO<UserInfo> = try await APIClient.shared.request(
                path: "/user/profile",
                method: .get
            )
            if let userName = userInfoResponse.data?.name {
                self.userName = userName
            }
        } catch {
            
        }
    }
    
    /// 설치된 앱 버전이 앱스토어 배포된 앱 버전보다 낮은지 확인
    func checkUpdateIsAvailable() async {
        let appStoreVersion = await self.fetchAppStoreVersion()
        self.isUpdateAvailable = compareVersions(self.appVersion, appStoreVersion) == .orderedAscending
    }
    
    func openAppStore() {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/id\(AppUpdateConfig.appStoreAppId)") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    /// appId 기반으로 앱스토어에 배포된 버전 fetch
    private func fetchAppStoreVersion() async -> String {
        let appId = AppUpdateConfig.appStoreAppId
        var components = URLComponents(string: "https://itunes.apple.com/lookup")
        components?.queryItems = [
            URLQueryItem(name: "id", value: appId),
            URLQueryItem(name: "country", value: Locale.current.region?.identifier.lowercased() ?? "kr")
        ]
        guard let url = components?.url else { return "" }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                return ""
            }
            struct LookupResponse: Decodable { let results: [AppInfo] }
            struct AppInfo: Decodable { let version: String }
            let decoded = try JSONDecoder().decode(LookupResponse.self, from: data)
            let version = decoded.results.first?.version ?? "cannot fetch version from app store."
            return version
        } catch {
            return ""
        }
    }
    
    /// 버전 비교 로직
    private func compareVersions(_ lhs: String, _ rhs: String) -> ComparisonResult {
        let lhsParts = lhs.split(separator: ".").map { Int($0) ?? 0 }
        let rhsParts = rhs.split(separator: ".").map { Int($0) ?? 0 }
        let maxCount = max(lhsParts.count, rhsParts.count)
        for i in 0..<maxCount {
            let l = i < lhsParts.count ? lhsParts[i] : 0
            let r = i < rhsParts.count ? rhsParts[i] : 0
            if l < r { return .orderedAscending }
            if l > r { return .orderedDescending }
        }
        return .orderedSame
    }
}

