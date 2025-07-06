//
//  AttributedString+Ext.swift
//  DDOBAK
//
//  Created by 이건우 on 7/6/25.
//

import UIKit
import SwiftUI

extension AttributedString {
    
    /// `boldText` 값은 `baseFont`기준으로 한 단계 높은 weight 폰트로 볼드처리 됩니다.
    static func makeAttributedString(
        text: String,
        boldText: [String]? = nil,
        baseFont: Font.DDOBAKFontStyle
    ) -> AttributedString {
        var attributed = AttributedString(text)
        
        let baseFontName = "WantedSans-\(baseFont.family.rawValue)"
        let baseUIFont = UIFont(name: baseFontName, size: baseFont.size) ?? .systemFont(ofSize: baseFont.size)
        attributed.inlinePresentationIntent = nil
        attributed.font = Font(baseUIFont)
        
        guard let boldText else { return attributed }

        let upgradedWeight = baseFont.family.upgradedWeight()
        let upgradedFontName = "WantedSans-\(upgradedWeight.rawValue)"
        
        for word in boldText {
            if let range = attributed.range(of: word) {
                let boldUIFont = UIFont(name: upgradedFontName, size: baseFont.size) ?? .boldSystemFont(ofSize: baseFont.size)
                attributed[range].font = Font(boldUIFont)
            }
        }

        return attributed
    }
}
