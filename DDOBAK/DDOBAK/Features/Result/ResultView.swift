//
//  ResultView.swift
//  DDOBAK
//
//  Created by 이건우 on 6/22/25.
//

import SwiftUI

struct ResultView: View {
        
    @State private var isLoading = true
    let images: [UIImage]
    
    var body: some View {
        VStack(spacing: 16) {
            if isLoading {
                ProgressView("분석 중입니다...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                Text("❗️분석 중 오류가 발생했어요.")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .padding()
        .navigationTitle("분석 결과")
        .task {
            await analyze()
        }
    }
    
    @MainActor
    private func analyze() async {
        isLoading = true

        try? await Task.sleep(nanoseconds: 2_000_000_000)

        isLoading = false
    }
}
