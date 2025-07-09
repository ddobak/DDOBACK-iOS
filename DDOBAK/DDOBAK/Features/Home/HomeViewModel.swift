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

    @MainActor
    func fetchUserAnalyses() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let response: ResponseDTO<AnalysesResult> = try await APIClient.shared.request(
                path: "/user/analyses"
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
