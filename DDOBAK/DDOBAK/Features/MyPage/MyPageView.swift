//
//  MyPageView.swift
//  DDOBAK
//
//  Created by 이건우 on 10/13/25.
//

import SwiftUI

struct MyPageView: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    @State private var viewModel: MyPageViewModel = .init()
    
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
        }
        .background(.mainWhite)
        .task {
            await viewModel.checkUpdateIsAvailable()
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
            
            Text("김또박")
                .font(.ddobak(.title3_sb20))
                .foregroundStyle(.mainBlack)
            
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
            
            MyPageActionSectionItem(
                title: "이름",
                content: "김또박",
                actionButtonTitle: "수정"
            )
            .onButtonTap {
                // ...
            }
            .padding(.top, 20)
        }
    }
    
    @ViewBuilder
    private var etcSection: some View {
        VStack(spacing: 14) {
            DdobakSectionItem(
                viewData: .init(
                    leadingItemText: "공지사항",
                    trailingItem: .icon(type: .arrow)
                )
            )
            
            DdobakSectionItem(
                viewData: .init(
                    leadingItemText: "정책",
                    trailingItem: .icon(type: .arrow)
                )
            )
            
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
}
