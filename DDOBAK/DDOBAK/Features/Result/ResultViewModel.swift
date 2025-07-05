//
//  ResultViewModel.swift
//  DDOBAK
//
//  Created by 이건우 on 6/23/25.
//

import SwiftUI
import Combine

let baseURLStr = "http://13.125.197.21:8080/api/contract/analysis"

@MainActor
final class ResultViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var analysisResult: String? // 예시용
    
    func analyze(images: [UIImage], contractType: String = "RENTAL") async {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = URL(string: baseURLStr) else {
            print("❌ Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer YOUR_ACCESS_TOKEN", forHTTPHeaderField: "Authorization")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let httpBody = createMultipartBody(images: images, contractType: contractType, boundary: boundary)
        
        do {
            let (data, response) = try await URLSession.shared.upload(for: request, from: httpBody)
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                print("❌ Server error")
                return
            }

            if let responseString = String(data: data, encoding: .utf8) {
                self.analysisResult = responseString
            }
        } catch {
            print("❌ Upload error: \(error)")
        }
    }
    
    private func createMultipartBody(images: [UIImage], contractType: String, boundary: String) -> Data {
        var body = Data()
        let lineBreak = "\r\n"
        
        // contractType field
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"contractType\"\(lineBreak + lineBreak)")
        body.append("\(contractType + lineBreak)")

        // image files
        for (index, image) in images.enumerated() {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"files\"; filename=\"image\(index).jpg\"\(lineBreak)")
                body.append("Content-Type: image/jpeg\(lineBreak + lineBreak)")
                body.append(imageData)
                body.append(lineBreak)
            }
        }
        
        // close boundary
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
}

// Data 확장
private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
