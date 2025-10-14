//
//  MyPageView.swift
//  DDOBAK
//
//  Created by 이건우 on 10/13/25.
//

import SwiftUI

struct MyPageView: View {
    
    @Environment(\.openURL) private var openURL
    @Environment(NavigationModel.self) private var navigationModel
    
    @State private var viewModel: MyPageViewModel = .init()
    
    /// 로그아웃, 탈퇴 관련 Alert 프로퍼티
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var alertConfirmAction: (() -> Void)? = nil
    
    private let noticeUrlStr: String = "https://possible-raft-360.notion.site/ddobak-notice"
    private let policyUrlStr: String = "https://possible-raft-360.notion.site/ddobak-privacy-policy"
    
    var body: some View {
        VStack(spacing: .zero) {
            TopNavigationBar(
                viewData: .init(
                    shouldShowleadingItem: true,
                    leadingItem: .backButton,
                    shouldShowNavigationTitle: false,
                    navigationTitle: nil,
                    shouldShowTrailingItem: false,
                    trailingItem: .none
                )
            )
            .setAppearance(.light)
            .onLeadingItemTap {
                navigationModel.pop()
            }
            
            /// 기본 사진 및 이름
            profileView
            
            Rectangle()
                .frame(height: 8)
                .foregroundStyle(.gray2)
            
            /// 기본 정보 섹션
            userInfoSection
                .padding(.top, 30)
            
            Spacer()
                .frame(height: 50)
            
            /// 기타 정보 섹션
            etcSection
            
            Spacer()
            
            Button {
                alertTitle = "⚠️ 정말 또박이를 떠나시겠어요?"
                alertMessage = "탈퇴 시 모든 분석 기록이 삭제돼요."
                alertConfirmAction = {
                    Task {
                        await viewModel.resign()
                        await MainActor.run {
                            navigationModel.popToRoot()
                        }
                    }
                }
                showAlert = true
                
            } label: {
                Text("탈퇴하기")
                    .font(.ddobak(.caption1_m16))
                    .foregroundStyle(.gray5)
                    .underline()
            }
            .padding(.bottom, 20)
        }
        .background(.mainWhite)
        .task {
            await viewModel.fetchUserInfo()
            await viewModel.checkUpdateIsAvailable()
        }
        .loadingOverlay(isLoading: $viewModel.isLoading)
        .alert(alertTitle, isPresented: $showAlert) {
            Button("취소", role: .cancel) {}
            Button("확인", role: .destructive) {
                alertConfirmAction?()
                alertConfirmAction = nil
            }
        } message: {
            Text(alertMessage)
        }
    }
}

private extension MyPageView {
    
    @ViewBuilder
    private var profileView: some View {
        VStack(spacing: .zero) {
            Spacer()
                .frame(height: 36)
            
            Image("kimddobak")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 140)
            
            Spacer()
                .frame(height: 20)
            
            if let name = viewModel.userName {
                Text(name)
                    .font(.ddobak(.title3_sb20))
                    .foregroundStyle(.mainBlack)
            } else {
                Text("김또박")
                    .font(.ddobak(.title3_sb20))
                    .foregroundStyle(.mainBlack)
                    .redacted(reason: .placeholder)
            }
            
            Spacer()
                .frame(height: 36)
        }
    }
    
    @ViewBuilder
    private var userInfoSection: some View {
        VStack(spacing: .zero) {
            DdobakSectionHeader(
                title: "기본 정보",
                titleColor: .mainBlack
            )
            
            if let name = viewModel.userName {
                MyPageActionSectionItem(
                    title: "이름",
                    content: name,
                    actionButtonTitle: "수정"
                )
                .onButtonTap {
                    navigationModel.push(.userInfoSetup(isEditing: true))
                }
                .padding(.top, 20)
            } else {
                MyPageActionSectionItem(
                    title: "이름",
                    content: "김또박",
                    actionButtonTitle: "수정"
                )
                .padding(.top, 20)
                .redacted(reason: .placeholder)
            }
        }
    }
    
    @ViewBuilder
    private var etcSection: some View {
        VStack(spacing: 16) {
            DdobakSectionItem(
                viewData: .init(
                    leadingItemText: "로그아웃",
                    trailingItem: .icon(type: .arrow)
                )
            )
            .onSectionItemTap {
                alertTitle = "🐦 또박이에서 로그아웃할까요?"
                alertMessage = "다시 로그인하면 분석 기록을 이어볼 수 있어요."
                alertConfirmAction = {
                    viewModel.logout()
                    navigationModel.popToRoot()
                }
                showAlert = true
            }
            
            DdobakSectionItem(
                viewData: .init(
                    leadingItemText: "공지사항",
                    trailingItem: .icon(type: .arrow)
                )
            )
            .onSectionItemTap {
                if let url = URL(string: noticeUrlStr) {
                    openURL(url)
                }
            }
            
            DdobakSectionItem(
                viewData: .init(
                    leadingItemText: "개인정보 처리방침",
                    trailingItem: .icon(type: .arrow)
                )
            )
            .onSectionItemTap {
                if let url = URL(string: policyUrlStr) {
                    openURL(url)
                }
            }
            
            DdobakSectionItem(
                viewData: .init(
                    leadingItemText: "버전",
                    trailingItem: .text(viewModel.appVersion)
                )
            )
            
            if viewModel.isUpdateAvailable {
                Button {
                    viewModel.openAppStore()
                } label: {
                    Text("사용 가능한 업데이트가 있어요")
                        .font(.ddobak(.caption3_r12))
                        .foregroundStyle(.mainBlue)
                        .underline()
                }
                .padding(.top, 10)
            }
        }
    }
}

#Preview {
    MyPageView()
        .environment(NavigationModel())
}

