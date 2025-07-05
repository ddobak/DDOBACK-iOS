//
//  SafeAreaInsetsKey.swift
//  DDOBAK
//
//  Created by 이건우 on 7/5/25.
//

import SwiftUI

private extension UIEdgeInsets {
    var swiftUiInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    
    @MainActor
    static var defaultValue: EdgeInsets {
        UIApplication.shared.keyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets()
    }
}

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}
