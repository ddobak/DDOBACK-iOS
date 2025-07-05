//
//  TopNavigationBar.swift
//  DDOBAK
//
//  Created by 이건우 on 7/5/25.
//

import SwiftUI

struct TopNavigationBarViewData: Equatable {
    var shouldShowBackButton: Bool
    var shouldShowNavigationTitle: Bool
    var navigationTitle: String?
    var shouldShowTrailingItem: Bool
    var trailingItem: TopNavigationTrailingItemType?
}

/// `leadingItem`은 backButton 밖에 존재하지 않아 따로 구현하지 않음
/// 추후 필요 시 구현 예정
enum TopNavigationTrailingItemType: Equatable {
    case text(String)
    case icon(type: TrailingItemIconType)
    
    enum TrailingItemIconType: String {
        case xmark = "xmark"
        case myPage = "person"
    }
}

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
            
            if viewData.shouldShowBackButton {
                /// `leadingItem`은 backButton
                Button {
                    leadingItemAction?()
                } label: {
                    Image("backArrow")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                }
            }
            
            Spacer()
            
            if viewData.shouldShowNavigationTitle {
                Text(viewData.navigationTitle.unwrapped())
                    .font(.ddobak(.body1_b16))
                    .lineLimit(1)
            }
            
            Spacer()
            
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
            
            Spacer()
                .frame(width: 20)
        }
        .frame(height: 42)
        .foregroundStyle(appearance.tintColor)
        .background(appearance.backgroundColor)
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

#Preview {
    VStack {
        TopNavigationBar(
            viewData: .init(
                shouldShowBackButton: true,
                shouldShowNavigationTitle: true,
                navigationTitle: "navigationTitle",
                shouldShowTrailingItem: true,
                trailingItem: .icon(type: .xmark)
            )
        )
        
        TopNavigationBar(
            viewData: .init(
                shouldShowBackButton: true,
                shouldShowNavigationTitle: true,
                navigationTitle: "navigationTitle",
                shouldShowTrailingItem: true,
                trailingItem: .text("완료")
            )
        )
        
        TopNavigationBar(
            viewData: .init(
                shouldShowBackButton: true,
                shouldShowNavigationTitle: true,
                navigationTitle: "navigationTitle",
                shouldShowTrailingItem: true
            )
        )
        .setAppearance(.dark)
    }
}
