//
//  ContentView.swift
//  DDOBAK
//
//  Created by 이건우 on 6/21/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var navigationModel: NavigationModel = .init()
    
    var body: some View {
        homeView
    }
}

private extension ContentView {
    
    @ViewBuilder
    var homeView: some View {
        @Bindable var navigationModel = navigationModel
        NavigationStack(path: $navigationModel.path) {
            SelectDocumentView()
        }
        .environment(navigationModel)
    }
}

#Preview {
    ContentView()
        .environment(NavigationModel())
}
