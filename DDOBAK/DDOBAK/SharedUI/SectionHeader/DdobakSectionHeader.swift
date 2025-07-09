//
//  DdobakSectionHeader.swift
//  DDOBAK
//
//  Created by 이건우 on 7/10/25.
//

import SwiftUI

struct DdobakSectionHeader: View {
    
    private let title: String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        HStack {
            Text(title)
                .lineLimit(1)
                .font(.ddobak(.body1_b16))
                .foregroundStyle(.mainBlack)
                .padding(.horizontal, 20)
            
            Spacer()
        }
        .frame(height: 20)
    }
}

#Preview {
    DdobakSectionHeader(title: "최근 분석 이력")
}
