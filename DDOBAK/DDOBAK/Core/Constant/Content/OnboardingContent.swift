//
//  OnboardingContent.swift
//  DDOBAK
//
//  Created by 이건우 on 10/12/25.
//

import Foundation

struct OnboardingContent: Hashable {
    let description: AttributedString
    let imageName: String
}

extension OnboardingContent {
    static func generate() -> [OnboardingContent] {
        return [
            OnboardingContent(
                description: .makeAttributedString(
                    text: "AI 비서 또박이에게\n계약서에 대한 정보를 입력해요",
                    boldText: ["계약서에 대한 정보를 입력해요"],
                    baseFont: .content1_r24
                ),
                imageName: "onboarding1"
            ),
            OnboardingContent(
                description: .makeAttributedString(
                    text: "계약서 속에 숨어 있는\n독소 조항을 찾을 수 있어요",
                    boldText: ["독소 조항을 찾을 수 있어요"],
                    baseFont: .content1_r24
                ),
                imageName: "onboarding2"
            ),
            OnboardingContent(
                description: .makeAttributedString(
                    text: "관련 판례를 참고하여\n안전하게 계약을 준비해요",
                    boldText: ["안전하게 계약을 준비해요"],
                    baseFont: .content1_r24
                ),
                imageName: "onboarding3"
            ),
        ]
    }
}
