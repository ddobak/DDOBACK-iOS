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
                    Text("아직 또박이가 분석한 계약서가 없어요")
                        .font(.ddobak(.body1_sb16))
                        .foregroundStyle(.gray5)
                        .centerAligned(adjustsForTopNavigationBar: true)
                } else if viewModel.errorMessage != nil {
                    Text("서비스에 일시적인 문제가 발생했어요\n잠시 후 다시 시도해주세요")
                        .font(.ddobak(.body1_sb16))
                        .foregroundStyle(.gray5)
                        .centerAligned(adjustsForTopNavigationBar: true)
                        .contextMenu {
                            Text(viewModel.errorMessage.unwrapped(placeholder: "Unknown Error"))
                        }
                } else {
                    ForEach(analyses, id: \.self) { analysis in
                        ContractAnalysisInfoCardView(viewData: analysis)
                            .onCardViewTap { contractData in
                                /// `ArchiveList`에서 분석 `cardView` 선택 시 `analysisStatus` 생략하고 바로 결과 페이지 노출됨.
                                navigationModel.push(.analysisResult(contractId: contractData.contractId,
                                                                     analysisId: contractData.analysisId))
                                
                                
                            }
                    }
                }
            }
        }
    }
}
