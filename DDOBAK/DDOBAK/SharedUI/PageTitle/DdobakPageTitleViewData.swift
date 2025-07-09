//
//  DdobakPageTitleViewData.swift
//  DDOBAK
//
//  Created by 이건우 on 7/6/25.
//

import SwiftUI

struct DdobakPageTitleViewData: Equatable {
    let title: String
    let subtitleType: DdobakPageTitleSubtitleStyle?
    let alignment: DdobakPageTitleAlignment
}

enum DdobakPageTitleSubtitleStyle: Equatable {
    case normal(String)
    case secondary(String)
    
    var subTitleColor: Color {
        switch self {
        case .normal: .mainBlack
        case .secondary: .gray5
        }
    }
}

enum DdobakPageTitleAlignment {
    case leading
    case center

    var swiftUIAlignment: Alignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        }
    }
}
