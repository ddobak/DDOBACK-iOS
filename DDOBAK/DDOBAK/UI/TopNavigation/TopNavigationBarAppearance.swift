//
//  TopNavigationBarAppearance.swift
//  DDOBAK
//
//  Created by 이건우 on 7/5/25.
//

import SwiftUI

enum TopNavigationBarAppearance {
    
    static let topNavigationBarHeight: CGFloat = 42
    
    case primary
    case light
    case dark

    var tintColor: Color {
        switch self {
        case .primary, .light:
            return .mainBlack
            
        case .dark:
            return .mainWhite
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .primary: return .lightBlue
        case .light: return .mainWhite
        case .dark: return .mainBlack
        }
    }
}
