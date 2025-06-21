//
//  NavigationModel.swift
//  DDOBAK
//
//  Created by 이건우 on 6/21/25.
//

import SwiftUI

@Observable
final class NavigationModel {
    
    var path: [NavigationDestinations]
    
    init(
        path: [NavigationDestinations] = [],
    ) {
        self.path = path
    }
}

extension NavigationModel {
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func pop() {
        path.removeLast(1)
    }
}

extension NavigationModel {
    enum NavigationDestinations: String, CaseIterable, Hashable {
        case temp
    }
}
