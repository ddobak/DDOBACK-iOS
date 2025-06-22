//
//  ResultView.swift
//  DDOBAK
//
//  Created by 이건우 on 6/22/25.
//

import SwiftUI

struct ResultView: View {
    
    let images: [UIImage]
    
    init(images: [UIImage]) {
        self.images = images
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 8) {
                ForEach(images.indices, id: \.self) { index in
                    Image(uiImage: images[index])
                        .resizable()
                        .scaledToFit()
                }
            }
            .padding(.horizontal, 16)
        }
    }
}
