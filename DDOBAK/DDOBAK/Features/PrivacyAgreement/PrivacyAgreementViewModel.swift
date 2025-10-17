//
//  PrivacyAgreementViewModel.swift
//  DDOBAK
//
//  Created by 이건우 on 7/6/25.
//

import SwiftUI

final class PrivacyAgreementViewModel: ObservableObject {
    
    let privacyAgreementData: [PrivacyAgreementData] = [
        .init(
            title: "수집 항목",
            content: "이미지 속 계약서에 포함된 정보 (이름, 주소, 전화번호 등)"
        ),
        .init(
            title: "이용 목적",
            content: """
            계약서 내 위험 조항 분석 및 요약 제공
            사용자 맞춤형 결과 리포트 생성
            서비스 품질 향상을 위한 익명 데이터 통계 처리
            """
        ),
        .init(
            title: "보관 및 이용 기간",
            content: """
            분석 완료 후 48시간 내 자동 삭제
            저장을 원하시는 경우 직접 저장 요청 시에만 보관
            """
        ),
        .init(
            title: "이용 동의 거부 시",
            content: "동의하지 않으실 경우, 계약서 분석 기능을 이용하실 수 없습니다."
        )
    ]
}

extension PrivacyAgreementViewModel {
    struct PrivacyAgreementData: Hashable {
        let title: String
        let content: String
    }
}
