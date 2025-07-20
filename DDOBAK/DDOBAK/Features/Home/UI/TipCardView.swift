//
//  TipCardView.swift
//  DDOBAK
//
//  Created by 이건우 on 7/20/25.
//

import SwiftUI

struct TipCardView: View, Equatable {
    
    private let viewData: Tip
    private var action: (((String)) -> Void)?
    
    init(viewData: Tip) {
        self.viewData = viewData
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            tags
            
            title
            
            summuary
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.mainWhite)
        }
        .onTapGesture {
            action?(viewData.id.description)
        }
    }
    
    static func == (lhs: TipCardView, rhs: TipCardView) -> Bool {
        return lhs.viewData == rhs.viewData
    }
}

// MARK: - Views
extension TipCardView {
    var tags: some View {
        HStack(spacing: 8) {
            ForEach(viewData.tags, id: \.self) { tagTitle in
                DdobakTag(
                    viewData: .init(
                        title: .makeAttributedString(text: tagTitle, baseFont: .caption2_m12),
                        titleColor: .mainBlue,
                        backgroundColor: .gray,
                        borderColor: .none
                    )
                )
            }
        }
    }
    
    var title: some View {
        Text(viewData.title)
            .font(.ddobak(.body1_sb16))
            .foregroundStyle(.mainBlack)
            .lineLimit(1)
    }
    
    var summuary: some View {
        Text(viewData.summary)
            .font(.ddobak(.caption2_m12))
            .foregroundStyle(.gray6)
            .lineLimit(1)
    }
}

// MARK: - Handlers
extension TipCardView {
    func onCardViewTap(action: @escaping ((String)) -> Void) -> Self {
        var newSelf = self
        newSelf.action = action
        return newSelf
    }
}

#Preview {
    TipCardView(
        viewData: .init(
            id: 1,
            title: "TipCardView",
            summary: "This is TipCadView",
            tags: ["tips, swiftui"],
            url: ""
        )
    )
}
