//
//  DdobakTag.swift
//  DDOBAK
//
//  Created by 이건우 on 7/6/25.
//

import SwiftUI

/// `DdobakTag`는 AttributeString을 지원합니다.
struct DdobakTag: View, Equatable {
    
    private let viewData: DdobakTagViewData
    
    init(viewData: DdobakTagViewData) {
        self.viewData = viewData
    }
    
    static func == (lhs: DdobakTag, rhs: DdobakTag) -> Bool {
        lhs.viewData == rhs.viewData
    }
    
    var body: some View {
        Text(viewData.title)
            .font(.ddobak(.caption2_m12))
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .foregroundStyle(viewData.titleColor.color)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(viewData.borderColor.color, lineWidth: 1)
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(viewData.backgroundColor.color)
            }
    }
}

#Preview {
    DdobakTag(viewData: .init(title: .makeAttributedString(text: "근로계약서", boldText: ["근로"], baseFont: .caption2_m12),
                              titleColor: .mainBlue,
                              backgroundColor: .lightBlue,
                              borderColor: .mainBlue)
    )
}
