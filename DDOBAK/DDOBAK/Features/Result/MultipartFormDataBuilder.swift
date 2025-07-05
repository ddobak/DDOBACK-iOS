//
//  MultipartFormDataBuilder.swift
//  DDOBAK
//
//  Created by 이건우 on 6/23/25.
//

import Foundation

//class MultipartFormDataBuilder {
//    private let boundary: String
//    private var body = Data()
//    private let lineBreak = "\r\n"
//    
//    init(boundary: String) {
//        self.boundary = boundary
//    }
//    
//    func addTextField(name: String, value: String) {
//        body.append("--\(boundary)\(lineBreak)")
//        body.append("Content-Disposition: form-data; name=\"\(name)\"\(lineBreak)\(lineBreak)")
//        body.append("\(value)\(lineBreak)")
//    }
//    
//    func addFileField(name: String, filename: String, data: Data, mimeType: String) {
//        body.append("--\(boundary)\(lineBreak)")
//        body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\(lineBreak)")
//        body.append("Content-Type: \(mimeType)\(lineBreak)\(lineBreak)")
//        body.append(data)
//        body.append(lineBreak)
//    }
//    
//    func build() -> Data {
//        body.append("--\(boundary)--\(lineBreak)")
//        return body
//    }
//}
