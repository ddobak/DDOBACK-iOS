//
//  LoadableStyle.swift
//  DDOBAK
//
//  Created by 이건우 on 7/13/25.
//

import SwiftUI

struct LoadableStyle: ViewModifier {
    @Binding var isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .allowsTightening(false)
            
            if isLoading {
                Color.black.opacity(0.2)
                    .ignoresSafeArea(.all)
                
                ProgressView()
                    .ignoresSafeArea(.all)
            }
        }
    }
}

extension View {
    func loadingOverlay(
        isLoading: Binding<Bool>
    ) -> some View {
        self.modifier(LoadableStyle(isLoading: isLoading))
    }
}
