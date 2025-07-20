//
//  HomeView.swift
//  DDOBAK
//
//  Created by 이건우 on 7/5/25.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    
    @State private var viewModel: HomeViewModel = .init()
    
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
                isShowingMyPageWarning = true
            }
            .alert("[TestFlight Mode] Cannot Access", isPresented: $isShowingMyPageWarning) {
                Button("OK", role: .cancel) { }
            } message: {
                
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
                    
                    recentAnalysesSection
                    
                    Spacer()
                        .frame(height: 36)
                    
                    honeyTips
                    
                    #if DEBUG
                    debugOption
                        .padding(.vertical, 30)
                    #endif
                    
                    Spacer()
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
                DDOBakLogger.log(errorMessage, level: .debug, category: .feature(featureName: "Home"))
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
    }
    
    private var mainBanner: some View {
        Image("mainThumbnail")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .buttonShadow()
    }
    
    private var mainFeatureNavigator: some View {
        HStack(spacing: 10) {
            Button {
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
                    ForEach(recentAnalyses, id: \.self) { analysis in
                        ContractAnalysisInfoCardView(viewData: analysis)
                            .onCardViewTap { contractId, analysisId in
                                navigationModel.push(.analysisResult(contractId: contractId, analysisId: analysisId))
                            }
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

