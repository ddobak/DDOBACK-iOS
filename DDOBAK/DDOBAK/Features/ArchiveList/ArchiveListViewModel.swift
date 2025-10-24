//
//  ArchiveListViewModel.swift
//  DDOBAK
//
//  Created by 이건우 on 7/20/25.
//

import SwiftUI
import Alamofire

@Observable
final class ArchiveListViewModel {
    
    var archivedAnalyses: [Contract]?
    
    var isLoading: Bool = false
    var errorMessage: String?
    var showErrorAlert: Bool = false
    
    @MainActor
    func refresh() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 300_000_000)
        await fetchArchivedAnalyses()
    }
    
    @MainActor
    func fetchArchivedAnalyses() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let response: ResponseDTO<AnalysesResult> = try await APIClient.shared.request(
                path: "/user/analyses",
                method: .get
            )
            
            archivedAnalyses = response.data?.contracts
            
        } catch {
            handleError(error: error)
        }
    }
    
    @MainActor
    func deleteArchivedAnalysis(contractId: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let response: ResponseDTO<Empty> = try await APIClient.shared.request(
                path: "/contract/\(contractId)",
                method: .delete
            )
            
            guard response.success == true else {
                throw APIError.statusCode(response.code)
            }
            
            withAnimation {
                /// 로컬에서 바로 삭제
                archivedAnalyses?.removeAll { $0.id == contractId }
            }
            
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
        showErrorAlert = true
    }
}
