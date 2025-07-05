//
//  ResultView.swift
//  DDOBAK
//
//  Created by 이건우 on 6/22/25.
//

import SwiftUI

struct ResultView: View {
        
    @StateObject var viewModel: ResultViewModel = .init()
    @State private var isLoading = true
    let images: [UIImage]
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("분석 중입니다...")
                    .padding()
            } else if let result = viewModel.analysisResult {
                ScrollView {
                    Text(result)
                        .padding()
                }
            } else {
                Text("아직 분석을 시작하지 않았습니다.")
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            Task {
                await viewModel.analyze(images: images)
            }
        }
    }
}
