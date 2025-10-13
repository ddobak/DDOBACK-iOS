//
//  DdobakSectionItem.swift
//  DDOBAK
//
//  Created by 이건우 on 10/13/25.
//

import SwiftUI

struct DdobakSectionItem: View, Equatable {
    private let viewData: DdobakSectionItemViewData
    private var action: (() -> Void)?

    init(viewData: DdobakSectionItemViewData) {
        self.viewData = viewData
    }
    
    static func == (lhs: DdobakSectionItem, rhs: DdobakSectionItem) -> Bool {
        lhs.viewData == rhs.viewData
    }

    
    var body: some View {
        HStack(spacing: .zero) {
            leadingItem
                .padding(.leading, 20)
            
            Spacer()
            
            buildTrailingItem(type: viewData.trailingItem)
                .padding(.trailing, 20)
        }
        .onTapGesture {
            /// `trailingItem`이 `.icon`일때만 액션 처리
            guard case .icon = viewData.trailingItem else { return }
            action?()
        }
    }
}

private extension DdobakSectionItem {
    
    var leadingItem: some View {
        Text(viewData.leadingItemText)
            .font(.ddobak(.body1_m16))
    }
    
    @ViewBuilder
    func buildTrailingItem(type: DdobakSectionTrailingItemType) -> some View {
        switch type {
        case .text(let string):
            Text(string)
                .font(.ddobak(.caption1_m16))
                .foregroundStyle(.gray5)
            
        case .icon(let iconType):
            Image(iconType.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 12, height: 12)
                .foregroundStyle(.gray6)
        }
    }
}

extension DdobakSectionItem {
    func onSectionItemTap(action: @escaping () -> Void) -> Self {
        var newSelf = self
        newSelf.action = action
        return newSelf
    }
}

#Preview {
    DdobakSectionItem(
        viewData: .init(
            leadingItemText: "공지사항",
            trailingItem: .icon(type: .arrow)
        )
    )
    .onSectionItemTap {
        print("!")
    }
}
