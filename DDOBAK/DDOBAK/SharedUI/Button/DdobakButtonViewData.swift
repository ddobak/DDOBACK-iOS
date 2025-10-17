//
//  DdobakButtonViewData.swift
//  DDOBAK
//
//  Created by 이건우 on 7/6/25.
//

import SwiftUI

struct DdobakButtonAppearance: Equatable {
    static let height: CGFloat = 56
    static let cornerRadius: CGFloat = 12
}

struct DdobakButtonViewData: Equatable {
    let title: String
    let buttonType: DdobakButtonType
    var isEnabled: Bool
    var isLoading: Bool
}

enum DdobakButtonType {
    
    case primary
    case white
    
    var textColor: Color {
        switch self {
        case .primary: .mainWhite
        case .white: .mainBlue
        }
    }
    
    var disabledTextColor: Color {
        switch self {
        case .primary, .white:
            return .gray5
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .primary: .mainBlue
        case .white: .mainWhite
        }
    }
    
    var disabledBackgroundColor: Color {
        switch self {
        case .primary, .white:
            return .gray3
        }
    }
    
    var pressedBackgroundColor: Color {
        switch self {
        case .primary: .pressedBlue
        case .white: .mainWhite
        }
    }
    
    var borderColor: Color {
        switch self {
        case .primary: .clear
        case .white: .mainBlue
        }
    }
    
    var disabledBorderColor: Color {
        switch self {
        case .primary, .white:
            return .gray3
        }
    }
    
    var loadingBorderColor: Color {
        switch self {
        case .primary: .clear
        case .white: .gray3
        }
    }
    
    var loadingIconColor: Color {
        switch self {
        case .primary: .mainWhite
        case .white: .gray4
        }
    }
}
