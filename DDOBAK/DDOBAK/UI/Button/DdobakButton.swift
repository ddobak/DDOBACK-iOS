//
//  DdobakButton.swift
//  DDOBAK
//
//  Created by 이건우 on 7/6/25.
//

import SwiftUI

struct DdobakButton: View, Equatable {
    
    private let viewData: DdobakButtonViewData
    private var action: (() -> Void)?

    init(viewData: DdobakButtonViewData, action: @escaping () -> Void = {}) {
        self.viewData = viewData
        self.action = action
    }
    
    static func == (lhs: DdobakButton, rhs: DdobakButton) -> Bool {
        lhs.viewData == rhs.viewData
    }
    
    var body: some View {
        Button {
            if viewData.isEnabled && !viewData.isLoading {
                action?()
            }
        } label: {
            if viewData.isLoading {
                Image("loading")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(viewData.buttonType.loadingIconColor)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                
            } else {
                Text(viewData.title)
                    .font(.ddobak(.button2_m16))
                    .foregroundStyle(viewData.isEnabled ? viewData.buttonType.textColor : viewData.buttonType.disabledTextColor)
                    .frame(maxWidth: .infinity, minHeight: DdobakButtonAppearance.height)
            }
        }
        .frame(height: DdobakButtonAppearance.height)
        .disabled(!viewData.isEnabled || viewData.isLoading)
        .buttonStyle(DdobakButtonStyle(viewData: viewData))
        .padding(.horizontal, 20)
    }
}

extension DdobakButton {
    func onButtonTap(action: @escaping () -> Void) -> Self {
        var newSelf = self
        newSelf.action = action
        return newSelf
    }
}

#Preview {
    DdobakButton(
        viewData: .init(
            title: "다음",
            buttonType: .primary,
            isEnabled: true,
            isLoading: true
        )
    )
    .onButtonTap {
        print("!")
    }
}
