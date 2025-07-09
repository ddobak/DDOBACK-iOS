//
//  DdobakShadowStyle.swift
//  DDOBAK
//
//  Created by 이건우 on 7/6/25.
//

import SwiftUI

extension View {
    func buttonShadow() -> some View {
        self.shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 0)
    }
}
