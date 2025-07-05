//
//  ResultView.swift
//  DDOBAK
//
//  Created by 이건우 on 6/22/25.
//

import SwiftUI

struct ResultView: View {
    let images: [UIImage]
    
    var body: some View {
        Image(uiImage: images.first!)
    }
}
