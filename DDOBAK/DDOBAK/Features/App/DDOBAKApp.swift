//
//  DDOBAKApp.swift
//  DDOBAK
//
//  Created by 이건우 on 6/21/25.
//

import SwiftUI

@main
struct DDOBAKApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
