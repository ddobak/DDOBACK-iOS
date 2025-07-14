//
//  ContractAnalysisInfoCardView.swift
//  DDOBAK
//
//  Created by 이건우 on 7/10/25.
//

import SwiftUI

/// 계약서 분석 결과 정보를 표시하는 `Card View`
struct ContractAnalysisInfoCardView: View {
    
    @State private var angle: Double = 0
    
    private let viewData: Contract
    private var action: (((String, String)) -> Void)?
    
    init(viewData: Contract) {
        self.viewData = viewData
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(viewData.contractType.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    DdobakTag(
                        viewData: .init(
                            title: .makeAttributedString(text: viewData.contractType.displayName,
                                                         baseFont: .caption2_m12),
                            titleColor: .mainBlue,
                            backgroundColor: .gray,
                            borderColor: .none
                        )
                    )
                    
                    Spacer()
                    
                    buildAnalysisStatusView(data: viewData)
                }
                
                Text(viewData.contractTitle)
                    .font(.ddobak(.body1_sb16))
                    .foregroundStyle(.mainBlack)
                
                Text(viewData.analysisDate)
                    .font(.ddobak(.caption2_m12))
                    .foregroundStyle(.gray5)
            }
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.mainWhite)
                .buttonShadow()
        }
        .onTapGesture {
            // 분석 중이 아닐때만 액션 처리
            if viewData.analysisStatus != .inProgress {
                action?((viewData.contractId, viewData.analysisId))
            }
        }
    }
}

extension ContractAnalysisInfoCardView {
    func onCardViewTap(action: @escaping ((String, String)) -> Void) -> Self {
        var newSelf = self
        newSelf.action = action
        return newSelf
    }
}

extension ContractAnalysisInfoCardView {
    
    @ViewBuilder
    private func buildAnalysisStatusView(data: Contract) -> some View {
        switch data.analysisStatus {
        case .inProgress:
            HStack(spacing: 4) {
                Image("ddobakProcessing")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14)
                    .rotationEffect(.degrees(angle))
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                            angle = 40
                        }
                    }
                
                Text("분석 중")
                    .font(.ddobak(.caption2_m12))
            }
            .foregroundStyle(.gray6)
            
        case .completed:
            if data.toxicCounts > 0 {
                Text("독소 조항 \(data.toxicCounts)건 발견")
                    .font(.ddobak(.caption2_m12))
                    .foregroundStyle(.mainBlue)
            } else {
                Text("독소 조항 없음")
                    .font(.ddobak(.caption2_m12))
                    .foregroundStyle(.gray5)
            }
            
        case .failed:
            Text("분석 실패")
                .font(.ddobak(.caption2_m12))
                .foregroundStyle(.mainRed)
        }
    }
}

#Preview {
    ContractAnalysisInfoCardView(
        viewData: .init(
            contractId: "1234567890",
            contractTitle: "서울시 강남구 소재 원룸 임대차 계약서",
            contractType: .employment,
            analysisStatus: .inProgress,
            analysisId: "1234567890",
            toxicCounts: 0,
            analysisDate: "2025-01-01"
        )
    )
}
