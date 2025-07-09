//
//  DdobakButtonStyle.swift
//  DDOBAK
//
//  Created by 이건우 on 7/6/25.
//

import SwiftUI

struct DdobakButtonStyle: ButtonStyle {
    
    let viewData: DdobakButtonViewData
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                RoundedRectangle(cornerRadius: DdobakButtonAppearance.cornerRadius)
                    .foregroundStyle(
                        configuration.isPressed
                        ? viewData.buttonType.pressedBackgroundColor
                        : backgroundColor(for: configuration)
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: DdobakButtonAppearance.cornerRadius)
                    .stroke(borderColor(for: configuration), lineWidth: 1)
            }
    }
    
    private func backgroundColor(for configuration: Configuration) -> Color {
        if !viewData.isEnabled {
            return viewData.buttonType.disabledBackgroundColor
        } else if viewData.isLoading {
            return viewData.buttonType.backgroundColor
        } else {
            return viewData.buttonType.backgroundColor
        }
    }
    
    private func borderColor(for configuration: Configuration) -> Color {
        if !viewData.isEnabled {
            return viewData.buttonType.disabledBorderColor
        } else if viewData.isLoading {
            return viewData.buttonType.loadingBorderColor
        } else {
            return viewData.buttonType.borderColor
        }
    }
}
