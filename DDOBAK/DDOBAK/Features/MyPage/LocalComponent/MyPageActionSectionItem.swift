//
//  MyPageActionSectionItem.swift
//  DDOBAK
//
//  Created by 이건우 on 10/13/25.
//

import SwiftUI

struct MyPageActionSectionItem: View {
    
    private let title: String
    private let content: String
    private let actionButtonTitle: String
    private var action: (() -> Void)?
    
    init(
        title: String,
        content: String,
        actionButtonTitle: String
    ) {
        self.title = title
        self.content = content
        self.actionButtonTitle = actionButtonTitle
    }
    
    var body: some View {
        HStack(spacing: .zero) {
            Text(title)
                .font(.ddobak(.body1_m16))
                .foregroundStyle(.gray5)
                .frame(width: 56, alignment: .leading)
                .lineLimit(1)
            
            Text(content)
                .font(.ddobak(.body1_m16))
                .foregroundStyle(.mainBlack)
                .lineLimit(1)
            
            Spacer()
            
            Button {
                action?()
            } label: {
                DdobakTag(
                    viewData: .init(
                        title: .makeAttributedString(text: actionButtonTitle,
                                                     baseFont: .caption2_m12),
                        titleColor: .mainBlue,
                        backgroundColor: .gray,
                        borderColor: .none
                    )
                )
            }
            .padding(.leading, 30)
        }
        .frame(height: 25)
        .padding(.horizontal, 20)
    }
}

extension MyPageActionSectionItem {
    func onButtonTap(action: @escaping () -> Void) -> Self {
        var newSelf = self
        newSelf.action = action
        return newSelf
    }
}

#Preview {
    MyPageActionSectionItem(title: "가나", content: "가가가가ㅏ가가ㅏ가가가ㅏ가가ㅏㄱrkrk", actionButtonTitle: "수정")
}
