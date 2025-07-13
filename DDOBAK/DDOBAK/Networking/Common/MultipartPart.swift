//
//  MultipartPart.swift
//  DDOBAK
//
//  Created by 이건우 on 7/13/25.
//

import Foundation

struct MultipartPart {
    let name: String
    let filename: String?
    let mimeType: String?
    let data: Data

    init(name: String, data: Data) {
        self.name = name
        self.data = data
        self.filename = nil
        self.mimeType = nil
    }

    init(name: String, filename: String, mimeType: String, data: Data) {
        self.name = name
        self.filename = filename
        self.mimeType = mimeType
        self.data = data
    }
}
