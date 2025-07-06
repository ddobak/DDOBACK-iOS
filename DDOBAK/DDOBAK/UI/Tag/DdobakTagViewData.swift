//
//  DdobakTagViewData.swift
//  DDOBAK
//
//  Created by 이건우 on 7/6/25.
//

import SwiftUI

struct DdobakTagViewData: Equatable {
    let title: AttributedString
    let titleColor: DdobakTagColorType
    let backgroundColor: DdobakTagColorType
    let borderColor: DdobakTagColorType
    
    init(
        title: AttributedString,
        titleColor: DdobakTagColorType,
        backgroundColor: DdobakTagColorType,
        borderColor: DdobakTagColorType
    ) {
        self.title = title
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
    }
}

/// `DdobakTag`에서 사용되는 컬러 타입입니다.
enum DdobakTagColorType {
    case gray
    case mainWhite
    case mainBlue
    case lightBlue
    case `none`
    
    var color: Color {
        switch self {
        case .gray: .gray2
        case .mainWhite: .mainWhite
        case .mainBlue: .mainBlue
        case .lightBlue: .lightBlue
        case .none: .clear
        }
    }
}
