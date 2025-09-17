//
//  ArchiveListViewModel.swift
//  DDOBAK
//
//  Created by 이건우 on 7/20/25.
//

import SwiftUI

@Observable
final class ArchiveListViewModel {
    
    var archivedAnalyses: [Contract]?
    
    var isLoading: Bool = false
    var errorMessage: String?
    
    @MainActor
    func refresh() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 300_000_000)
        await fetchArchivedAnalyses()
    }
    
    @MainActor
    func fetchArchivedAnalyses() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response: ResponseDTO<AnalysesResult> = try await APIClient.shared.request(
                path: "/user/analyses",
                method: .get
            )
            
            archivedAnalyses = response.data?.contracts
            DDOBakLogger.log(archivedAnalyses, level: .info, category: .viewModel)
            
        } catch {
            handleError(error: error)
        }
    }
    
    private func clearData() {
        archivedAnalyses = nil
    }
    
    private func handleError(error: Error) {
        guard let error = error as? APIError else { return }
        errorMessage = error.localizedDescription
    }
}
