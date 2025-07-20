//
//  ArchiveListView.swift
//  DDOBAK
//
//  Created by 이건우 on 7/20/25.
//

import SwiftUI

struct ArchiveListView: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    @State private var viewModel: ArchiveListViewModel = .init()
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: TopNavigationBar
            TopNavigationBar(
                viewData: .init(
                    shouldShowleadingItem: true,
                    leadingItem: .backButton,
                    shouldShowNavigationTitle: true,
                    navigationTitle: "분석 결과 보관함",
                    shouldShowTrailingItem: true,
                    trailingItem: .none
                )
            )
            .setAppearance(.light)
            .onLeadingItemTap {
                navigationModel.pop()
            }
            .zIndex(1)
            
            // MARK: List View Area
            ScrollView {
                arhiveList
                    .animation(.easeInOut, value: viewModel.isLoading)
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 48)
            }
            .ignoresSafeArea(edges: .bottom)
            .padding(.top, TopNavigationBarAppearance.topNavigationBarHeight)
            .background(.mainWhite)
        }
        .task {
            await viewModel.fetchArchivedAnalyses()
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
}

extension ArchiveListView {
    private var arhiveList: some View {
        LazyVStack(spacing: 12) {
            if viewModel.isLoading {
                ForEach(0..<10, id: \.self) { _ in
                    ContractAnalysisInfoCardView(viewData: .mock())
                        .redacted(reason: .placeholder)
                }
            } else if let analyses = viewModel.archivedAnalyses {
                if analyses.isEmpty {
                    Image("emptyAnalysisResult")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .buttonShadow()
                } else {
                    ForEach(analyses, id: \.self) { analysis in
                        ContractAnalysisInfoCardView(viewData: analysis)
                            .onCardViewTap { contractId, analysisId in
                                navigationModel.push(.analysisResult(contractId: contractId, analysisId: analysisId))
                            }
                    }
                }
            }
        }
    }
}
