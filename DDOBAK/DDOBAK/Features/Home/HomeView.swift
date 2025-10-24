//
//  HomeView.swift
//  DDOBAK
//
//  Created by 이건우 on 7/5/25.
//

import SwiftUI
import BetterSafariView

struct HomeView: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    
    @State private var viewModel: HomeViewModel = .init()
    @State private var showNoticeWebView: Bool = false
    
    // for debug
    @State private var isShowingTokenAlert: Bool = false
    @State private var isShowingMyPageWarning: Bool = false
    @State private var tokenInput: String = ""
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: TopNavigationBar
            TopNavigationBar(
                viewData: .init(
                    shouldShowleadingItem: true,
                    leadingItem: .logo,
                    shouldShowNavigationTitle: false,
                    navigationTitle: nil,
                    shouldShowTrailingItem: true,
                    trailingItem: .icon(type: .myPage)
                )
            )
            .onTrailingItemTap {
                HapticManager.shared.selectionChanged()
                navigationModel.push(.myPage)
            }
            .zIndex(1)
            
            // MARK: Main Home Area
            ScrollView {
                VStack(spacing: .zero) {
                    
                    noticeBanner
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                    
                    mainBanner
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        
                    mainFeatureNavigator
                        .padding(.top, 12)
                        .padding(.horizontal, 20)
                    
                    Spacer()
                        .frame(height: 36)
                    
                    /// 최근 분석 이력
                    recentAnalysesSection
                    
                    Spacer()
                        .frame(height: 36)
                    
                    /// 가이드 살펴보기
                    howToUse
                        .padding(.horizontal, 20)
                    
                    Spacer()
                        .frame(height: 36)
                    
                    honeyTips
                    
                    copyright
                        .padding(.vertical, 30)
                    
                    #if DEBUG
                    debugOption
                        .padding(.vertical, 30)
                    #endif
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .padding(.top, TopNavigationBarAppearance.topNavigationBarHeight)
            .background(.lightBlue)
            .refreshable {
                await viewModel.refresh()
            }
            .onChange(of: viewModel.errorMessage) { _, errorMessage in
                guard let errorMessage else { return }
                DDOBakLogger.log(errorMessage, level: .error, category: .feature(featureName: "Home"))
            }
            .task {
                await viewModel.fetchUserAnalyses()
                await viewModel.fetchTips()
            }
        }
    }
}

extension HomeView {
        
    @ViewBuilder
    private var noticeBanner: some View {
        let noticeText: String = "📄 이제 PDF 업로드도 지원돼요!"
        
        HStack(spacing: 12) {
            DdobakTag(
                viewData: .init(
                    title: .makeAttributedString(text: "소식", baseFont: .caption2_m12),
                    titleColor: .mainWhite,
                    backgroundColor: .mainBlue,
                    borderColor: .none
                )
            )
            
            Text(noticeText)
                .font(.ddobak(.caption2_m12))
                .foregroundStyle(.mainBlue)
            
            Spacer()
        }
        .padding(.vertical, 11)
        .padding(.horizontal, 16)
        .background {
            Capsule()
                .foregroundStyle(.mainBlue.opacity(0.1))
        }
        .onTapGesture {
            showNoticeWebView = true
        }
        .safariView(isPresented: $showNoticeWebView) {
            SafariView(url: .init(string: NotionWebViewConfig.noticeUrlStr)!)
        }
    }
    
    private var mainBanner: some View {
        Image("mainThumbnail")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .buttonShadow()
            .onTapGesture {
                HapticManager.shared.selectionChanged()
                navigationModel.push(.selectContractType)
            }
    }
    
    private var mainFeatureNavigator: some View {
        HStack(spacing: 10) {
            Button {
                HapticManager.shared.selectionChanged()
                navigationModel.push(.selectContractType)
            } label: {
                Image("analysis")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .buttonShadow()
            }
            
            Button {
                HapticManager.shared.selectionChanged()
                navigationModel.push(.archiveList)
            } label: {
                Image("archive")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .buttonShadow()
            }
        }
    }
    
    private var recentAnalysesSection: some View {
        
        VStack(spacing: 20) {
            DdobakSectionHeader(
                title: "최근 분석 이력",
                titleColor: .mainBlack
            )
            
            VStack(spacing: 12) {
                if let recentAnalyses = viewModel.recentAnalyses {
                    if recentAnalyses.isEmpty {
                        Image("emptyAnalysisResult")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .buttonShadow()
                    } else {
                        ForEach(recentAnalyses, id: \.self) { analysis in
                            ContractAnalysisInfoCardView(viewData: analysis)
                                .onCardViewTap { contractData in
                                    /// `HomeView`에서 분석 `cardView` 선택 시 `analysisStatus` 노출 (이후에 결과 페이지 노출됨)
                                    navigationModel.push(.analysisStatus(analysisStatus: contractData.analysisStatus,
                                                                         contractData: contractData))
                                }
                        }
                    }
                } else if viewModel.isRecentAnalysesFetchFailed == true {
                    Image("fetchError")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .buttonShadow()
                        .contextMenu {
                            Text(viewModel.errorMessage.unwrapped(placeholder: "Unknown error"))
                        }
                } else {
                    ForEach(0..<3, id: \.self) { _ in
                        ContractAnalysisInfoCardView(viewData: .mock())
                            .redacted(reason: .placeholder)
                    }
                }
            }
            .animation(.easeInOut, value: viewModel.recentAnalyses)
            .padding(.horizontal, 20)
        }
    }
    
    @ViewBuilder
    private var howToUse: some View {
        Image("howToUse")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .onTapGesture {
                navigationModel.push(.howToUse)
            }
    }
    
    private var honeyTips: some View {
        VStack(spacing: 20) {
            DdobakSectionHeader(
                title: "또박이의 계약 꿀팁",
                titleColor: .mainWhite
            )
            
            VStack(spacing: 12) {
                if let tips = viewModel.tips {
                    ForEach(tips, id: \.self) { tip in
                        TipCardView(viewData: tip)
                            .onCardViewTap { tipId in
                                navigationModel.push(.honeyTip(tipId: tipId))
                            }
                    }
                } else if viewModel.isTipsFetchFailed == true {
                    Image("fetchError")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .buttonShadow()
                } else {
                    ForEach(0..<3, id: \.self) { _ in
                        TipCardView(viewData: .mock())
                            .redacted(reason: .placeholder)
                    }
                }
            }
            .padding(.horizontal, 20)
            .animation(.easeInOut, value: viewModel.tips)
        }
        .padding(.top, 20)
        .padding(.bottom, 24)
        .background(Color.mainBlue)
    }
    
    private var copyright: some View {
        Text("© 2025 DDOBAK. All rights reserved.")
            .font(.ddobak(.caption3_r12))
            .foregroundStyle(.gray6)
    }
}

extension HomeView {
    private var debugOption: some View {
        DdobakTag(
            viewData: .init(
                title: "DEBUG OPTION",
                titleColor: .mainBlue,
                backgroundColor: .lightBlue,
                borderColor: .mainBlue)
        )
        .buttonShadow()
        .onTapGesture {
            isShowingTokenAlert = true
        }
        .alert("[TestFlight Mode] Access Token", isPresented: $isShowingTokenAlert) {
            TextField("Input AccessToken", text: $tokenInput)
            Button("Save") {
                UserDefaults.standard.set(tokenInput, forKey: "accessToken")
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            
        }
    }
}

#Preview {
    HomeView()
        .environment(NavigationModel())
}

