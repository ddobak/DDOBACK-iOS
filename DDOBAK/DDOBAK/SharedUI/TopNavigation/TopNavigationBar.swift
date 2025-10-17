//
//  TopNavigationBar.swift
//  DDOBAK
//
//  Created by 이건우 on 7/5/25.
//

import SwiftUI

struct TopNavigationBar: View, Equatable {
    
    private let viewData: TopNavigationBarViewData
    private var appearance: TopNavigationBarAppearance = .primary
    private var leadingItemAction: (() -> Void)?
    private var trailingItemAction: (() -> Void)?
    
    init(viewData: TopNavigationBarViewData) {
        self.viewData = viewData
    }
    
    static func == (lhs: TopNavigationBar, rhs: TopNavigationBar) -> Bool {
        lhs.viewData == rhs.viewData
    }
    
    var body: some View {
        HStack(spacing: .zero) {
            
            Spacer()
                .frame(width: 20)
            
            buildLeadingItem()
            
            Spacer()
            
            if viewData.shouldShowNavigationTitle {
                Text(viewData.navigationTitle.unwrapped())
                    .font(.ddobak(.body1_b16))
                    .lineLimit(1)
            }
            
            Spacer()
            
            buildTrailingItem()
            
            Spacer()
                .frame(width: 20)
        }
        .frame(height: TopNavigationBarAppearance.topNavigationBarHeight)
        .foregroundStyle(appearance.tintColor)
        .background(appearance.backgroundColor)
    }
    
    @ViewBuilder
    private func buildLeadingItem() -> some View {
        if viewData.shouldShowleadingItem {
            /// `leadingItem`은 backButton
            Button {
                leadingItemAction?()
            } label: {
                switch viewData.leadingItem {
                case .backButton:
                    Image("backArrow")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                    
                case .logo:
                    Image("ddobakLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.vertical, 10)
                    
                case .none:
                    Color.clear
                        .frame(width: 20, height: 20)
                }
            }
        } else {
            Color.clear
                .frame(width: 20, height: 20)
        }
    }
    
    @ViewBuilder
    private func buildTrailingItem() -> some View {
        if viewData.shouldShowTrailingItem {
            Button {
                trailingItemAction?()
            } label: {
                switch viewData.trailingItem {
                case .text(let string):
                    Text(string)
                        .font(.ddobak(.button2_m16))
                        .lineLimit(1)
                    
                case .icon(let iconType):
                    Image(iconType.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                    
                case .none:
                    Color.clear
                        .frame(width: 20, height: 20)
                }
            }
        }
    }
}

extension TopNavigationBar {
    func setAppearance(_ appearance: TopNavigationBarAppearance) -> Self {
        var newSelf = self
        newSelf.appearance = appearance
        return newSelf
    }
    
    func onLeadingItemTap(action: @escaping () -> Void) -> Self {
        var newSelf = self
        newSelf.leadingItemAction = action
        return newSelf
    }
    
    func onTrailingItemTap(action: @escaping () -> Void) -> Self {
        var newSelf = self
        newSelf.trailingItemAction = action
        return newSelf
    }
}

#Preview("primary / logo") {
    TopNavigationBar(
        viewData: .init(
            shouldShowleadingItem: true,
            leadingItem: .logo,
            shouldShowNavigationTitle: false,
            navigationTitle: "navigationTitle",
            shouldShowTrailingItem: true,
            trailingItem: .icon(type: .xmark)
        )
    )
    .setAppearance(.primary)
}

#Preview("light / leading") {
    TopNavigationBar(
        viewData: .init(
            shouldShowleadingItem: true,
            leadingItem: .backButton,
            shouldShowNavigationTitle: true,
            navigationTitle: "navigationTitle",
            shouldShowTrailingItem: false,
            trailingItem: .none
        )
    )
    .setAppearance(.light)
}

#Preview("dark / trailing") {
    TopNavigationBar(
        viewData: .init(
            shouldShowleadingItem: false,
            leadingItem: .none,
            shouldShowNavigationTitle: true,
            navigationTitle: "navigationTitle",
            shouldShowTrailingItem: true,
            trailingItem: .text("완료")
        )
    )
    .setAppearance(.dark)
}


