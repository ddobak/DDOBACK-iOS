//
//  WelcomeView.swift
//  DDOBAK
//
//  Created by 이건우 on 10/15/25.
//

import SwiftUI

struct WelcomeView: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    private let userName: String
    
    init(userName: String) {
        self.userName = userName
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            Spacer()
            
            Image("welcome")
                .resizable()
                .scaledToFit()
                
            Spacer()
                .frame(height: 40)
            
            DdobakPageTitle(
                viewData: .init(
                    title: "반가워요 \(userName)님!",
                    subtitleType: .normal("사진 한 장이면 끝!\n또박이가 독소 조항을 딱! 짚어드릴게요."),
                    alignment: .center
                )
            )
            
            Spacer()
            
            DdobakButton(
                viewData: .init(
                    title: "바로 분석 시작하기",
                    buttonType: .primary,
                    isEnabled: true,
                    isLoading: false
                )
            )
            .onButtonTap {
                navigationModel.popToRoot()
            }
            .padding(.bottom, 16)
        }
        .background(.mainWhite)
        .ignoresSafeArea(.all, edges: .top)
    }
}
