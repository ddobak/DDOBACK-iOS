//
//  CheckOCRResult.swift
//  DDOBAK
//
//  Created by 이건우 on 6/22/25.
//

import SwiftUI

struct CheckOCRResult: View {
    let images: [UIImage]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(images, id: \.self) { image in
                    Image(uiImage: image)
                }
            }
        }
    }
}
