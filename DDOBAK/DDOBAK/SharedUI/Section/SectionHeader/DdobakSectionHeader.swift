//
//  DdobakSectionHeader.swift
//  DDOBAK
//
//  Created by 이건우 on 7/10/25.
//

import SwiftUI

struct DdobakSectionHeader: View, Equatable {
    
    private let title: String
    private let titleColor: Color
    
    init(
        title: String,
        titleColor: Color
    ) {
        self.title = title
        self.titleColor = titleColor
    }
    
    var body: some View {
        HStack {
            Text(title)
                .lineLimit(1)
                .font(.ddobak(.body1_b16))
                .foregroundStyle(titleColor)
                .padding(.horizontal, 20)
            
            Spacer()
        }
        .frame(height: 20)
    }
    
    static func == (lhs: DdobakSectionHeader, rhs: DdobakSectionHeader) -> Bool {
        return lhs.title == rhs.title
    }
}

#Preview {
    DdobakSectionHeader(title: "최근 분석 이력", titleColor: .mainBlack)
}
