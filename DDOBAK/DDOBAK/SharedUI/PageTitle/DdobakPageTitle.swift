//
//  DdobakPageTitle.swift
//  DDOBAK
//
//  Created by 이건우 on 7/6/25.
//

import SwiftUI

struct DdobakPageTitle: View, Equatable {
    
    private let viewData: DdobakPageTitleViewData
    private var subTitle: String?
    
    init(viewData: DdobakPageTitleViewData) {
        self.viewData = viewData
        
        switch viewData.subtitleType {
        case .normal(let subTitle), .secondary(let subTitle):
            self.subTitle = subTitle
        case .none:
            subTitle = nil
        }
    }
    
    static func == (lhs: DdobakPageTitle, rhs: DdobakPageTitle) -> Bool {
        lhs.viewData == rhs.viewData
    }
    
    var body: some View {
        VStack(spacing: 14) {
            Text(viewData.title)
                .font(.ddobak(.title1_sb28))
                .lineLimit(2)
                .multilineTextAlignment(viewData.alignment.multiLineTextAlignment)
                .frame(maxWidth: .infinity, alignment: viewData.alignment.frameAlignment)
            
            if let subTitle {
                Text(subTitle)
                    .font(.ddobak(.body2_m14))
                    .foregroundStyle(viewData.subtitleType?.subTitleColor ?? .clear)
                    .lineLimit(2)
                    .multilineTextAlignment(viewData.alignment.multiLineTextAlignment)
                    .frame(maxWidth: .infinity, alignment: viewData.alignment.frameAlignment)
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    DdobakPageTitle(
        viewData: .init(
            title: "또박이가 부를\n이름을 입력해주세요.",
            subtitleType: .secondary("공백없이 10자 이하, 기호는 !@#$_  만 사용 가능합니다."),
            alignment: .leading
        )
    )
}
