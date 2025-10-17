//
//  HomeViewModel.swift
//  DDOBAK
//
//  Created by 이건우 on 7/10/25.
//

import SwiftUI

@Observable
final class HomeViewModel {
    
    var recentAnalyses: [Contract]?
    var isRecentAnalysesFetchFailed: Bool = false
    
    var tips: [Tip]?
    var isTipsFetchFailed: Bool = false
    
    var isLoading: Bool = false
    var errorMessage: String?
    
    @MainActor
    func refresh() async {
        clearData()
        
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        await fetchUserAnalyses()
        await fetchTips()
    }
    
    /// 홈 화면에서의 분석 결과 요청의 최대 개수는 최근 3개로 고정됩니다.
    @MainActor
    func fetchUserAnalyses(requestCount: Int = 3) async {
        isLoading = true
        isRecentAnalysesFetchFailed = false
        defer { isLoading = false }
        
        do {
            let queryItems = [URLQueryItem(name: "requestCount", value: "\(requestCount)")]
            
            let response: ResponseDTO<AnalysesResult> = try await APIClient.shared.request(
                path: "/user/analyses",
                method: .get,
                queryItems: queryItems
            )
            
            recentAnalyses = response.data?.contracts
            
        } catch {
            isRecentAnalysesFetchFailed = true
            handleError(error: error)
        }
    }
    
    @MainActor
    func fetchTips() async {
        isLoading = true
        isTipsFetchFailed = false
        defer { isLoading = false }
        
        do {
            let response: ResponseDTO<[Tip]> = try await APIClient.shared.request(
                path: "/tips",
                method: .get
            )
            
            tips = response.data
            
        } catch {
            isTipsFetchFailed = true
            handleError(error: error)
        }
    }
    
    private func clearData() {
        recentAnalyses = nil
        tips = nil
    }
    
    private func handleError(error: Error) {
        guard let error = error as? APIError else { return }
        errorMessage = error.localizedDescription
    }
}
