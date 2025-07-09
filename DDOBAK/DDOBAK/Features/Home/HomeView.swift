//
//  HomeView.swift
//  DDOBAK
//
//  Created by 이건우 on 7/5/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(NavigationModel.self) private var navigationModel
    
    // for debug
    @State private var isShowingTokenAlert: Bool = false
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
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                    
                    #if DEBUG
                    debugOption
                    #endif
                    
                    Spacer()
                }
            }
            .padding(.vertical, TopNavigationBarAppearance.topNavigationBarHeight)
            .background(.lightBlue)
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
                navigationModel.push(.selectDocumetType)
            } label: {
                Image("analysis")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .buttonShadow()
                    
            }
            
            Button {
                
            } label: {
                Image("archive")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .buttonShadow()
            }
        }
    }
}

extension HomeView {
    private var debugOption: some View {
        Text("DEBUG OPTION")
            .padding()
            .onTapGesture {
                isShowingTokenAlert = true
            }
            .alert("AccessToken", isPresented: $isShowingTokenAlert) {
                TextField("Input AccessToken", text: $tokenInput)
                Button("save") {
                    UserDefaults.standard.set(tokenInput, forKey: "accessToken")
                }
                Button("cancel", role: .cancel) { }
            } message: { }
    }
}

#Preview {
    HomeView()
        .environment(NavigationModel())
}

