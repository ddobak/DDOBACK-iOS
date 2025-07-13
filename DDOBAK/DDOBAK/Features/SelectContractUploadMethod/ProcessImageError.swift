//
//  ProcessImageError.swift
//  DDOBAK
//
//  Created by 이건우 on 7/6/25.
//

enum ProcessImageError: Error {
    case failedToLoadImage
    case sizeIsTooBig
    
    var localizedDescription: String {
        switch self {
        case .failedToLoadImage:
            return "이미지 로딩에 실패했습니다."
        case .sizeIsTooBig:
            return "이미지 크기가 너무 큽니다."
        }
    }
}
