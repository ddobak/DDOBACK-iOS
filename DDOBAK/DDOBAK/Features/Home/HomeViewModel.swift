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
    var isLoading: Bool = false
    var errorMessage: String?
    
    @MainActor
    func refresh() async {
        clearData()
        await fetchUserAnalyses()
    }
    
    /// 홈 화면에서의 분석 결과 요청의 최대 개수는 최근 3개로 고정됩니다.
    @MainActor
    func fetchUserAnalyses(requestCount: Int = 3) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let queryItems = [URLQueryItem(name: "requestCount", value: "\(requestCount)")]
            
            let response: ResponseDTO<AnalysesResult> = try await APIClient.shared.request(
                path: "/user/analyses",
                method: .get,
                queryItems: queryItems
            )
            recentAnalyses = response.data?.contracts
            DDOBakLogger.log(recentAnalyses, level: .info, category: .viewModel)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func clearData() {
        recentAnalyses = nil
    }
}
