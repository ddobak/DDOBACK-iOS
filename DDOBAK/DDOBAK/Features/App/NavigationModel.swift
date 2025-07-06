//
//  NavigationModel.swift
//  DDOBAK
//
//  Created by 이건우 on 6/21/25.
//

import SwiftUI

@Observable
final class NavigationModel {
    
    var path: [NavigationDestination]
    
    init(path: [NavigationDestination] = []) {
        self.path = path
    }
}

extension NavigationModel {
    
    func pop() {
        path.removeLast(1)
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func push(_ destination: NavigationDestination) {
        path.append(destination)
    }
}

extension NavigationModel {
    enum NavigationDestination: String, CaseIterable, Hashable {
        case selectDocumetType
        case privacyAgreement
        case selectDocumetUploadMethod
    }
}
