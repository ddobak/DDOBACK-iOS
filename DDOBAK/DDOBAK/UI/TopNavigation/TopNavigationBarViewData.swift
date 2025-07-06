//
//  TopNavigationBarViewData.swift
//  DDOBAK
//
//  Created by 이건우 on 7/6/25.
//

struct TopNavigationBarViewData: Equatable {
    var shouldShowleadingItem: Bool
    var leadingItem: TopNavigationLeadingItemType?
    var shouldShowNavigationTitle: Bool
    var navigationTitle: String?
    var shouldShowTrailingItem: Bool
    var trailingItem: TopNavigationTrailingItemType?
    
    init(
        shouldShowleadingItem: Bool,
        leadingItem: TopNavigationLeadingItemType?,
        shouldShowNavigationTitle: Bool,
        navigationTitle: String?,
        shouldShowTrailingItem: Bool,
        trailingItem: TopNavigationTrailingItemType?
    ) {
        self.shouldShowleadingItem = shouldShowleadingItem
        self.leadingItem = leadingItem
        self.shouldShowNavigationTitle = shouldShowNavigationTitle
        self.navigationTitle = navigationTitle
        self.shouldShowTrailingItem = shouldShowTrailingItem
        self.trailingItem = trailingItem
    }
}

enum TopNavigationLeadingItemType: Equatable {
    case backButton
    case logo
    
    var iconName: String {
        switch self {
        case .backButton:
            return "backArrow"
        case .logo:
            return "ddobakLogo"
        }
    }
}

enum TopNavigationTrailingItemType: Equatable {
    case text(String)
    case icon(type: TrailingItemIconType)
    
    enum TrailingItemIconType: String {
        case xmark = "xmark"
        case myPage = "person"
    }
}
