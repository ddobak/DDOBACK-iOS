//
//  RootView.swift
//  DDOBAK
//
//  Created by 이건우 on 6/21/25.
//

import SwiftUI

struct RootView: View {
    
    @State private var navigationModel: NavigationModel = .init()
    
    var body: some View {
        homeView
    }
}

private extension RootView {
    
    @ViewBuilder
    var homeView: some View {
        @Bindable var navigationModel = navigationModel
        
        NavigationStack(path: $navigationModel.path) {
            HomeView()
                .navigationDestination(for: NavigationModel.NavigationDestination.self) { destination in
                    Group {
                        switch destination {
                        case .selectDocumet:
                            EmptyView()
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                }
        }
        .environment(navigationModel)
    }
}

#Preview {
    RootView()
        .environment(NavigationModel())
}
