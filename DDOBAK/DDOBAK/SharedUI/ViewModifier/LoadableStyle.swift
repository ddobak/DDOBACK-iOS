//
//  LoadableStyle.swift
//  DDOBAK
//
//  Created by 이건우 on 7/13/25.
//

import SwiftUI

struct LoadableStyle: ViewModifier {
    @Binding var isLoading: Bool
    private let opacity: CGFloat
    private let tintColor: Color?
    
    init(
        isLoading: Binding<Bool>,
        opacity: CGFloat,
        tintColor: Color?
    ) {
        self._isLoading = isLoading
        self.opacity = opacity
        self.tintColor = tintColor
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .allowsTightening(false)
            
            if isLoading {
                Color.black.opacity(opacity)
                    .ignoresSafeArea(.all)
                
                ProgressView()
                    .ignoresSafeArea(.all)
                    .tint(tintColor)
            }
        }
    }
}

extension View {
    func loadingOverlay(
        isLoading: Binding<Bool>,
        opacity: CGFloat = 0.2,
        tintColor: Color? = nil
    ) -> some View {
        self.modifier(LoadableStyle(isLoading: isLoading, opacity: opacity, tintColor: tintColor))
    }
}
