//
//  HomeViewModel.swift
//  DDOBAK
//
//  Created by 이건우 on 7/10/25.
//

import SwiftUI

@Observable
final class HomeViewModel {
    
    var contracts: [Contract]? = []
    var isLoading: Bool = false
    var errorMessage: String?

    @MainActor
    func fetchUserAnalyses() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let response: ResponseDTO<AnalysesResult> = try await APIClient.shared.request(
                path: "/user/analyses"
            )
            contracts = response.data?.contracts
            DDOBakLogger.log(contracts, level: .info, category: .viewModel)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
