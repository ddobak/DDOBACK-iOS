//
//  View+Ext.swift
//  DDOBAK
//
//  Created by 이건우 on 10/13/25.
//

import SwiftUI

extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func centerAligned(adjustsForTopNavigationBar: Bool) -> some View {
        self
            .containerRelativeFrame(.vertical, alignment: .center)
            .padding(.bottom, adjustsForTopNavigationBar ? TopNavigationBarAppearance.topNavigationBarHeight : .zero)
    }
}
