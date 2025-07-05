//
//  MaskingVIewModel.swift
//  DDOBAK
//
//  Created by 이건우 on 6/21/25.
//

import SwiftUI
import Combine
import PencilKit

final class MaskingViewModel: ObservableObject {

    // MARK: - Properties

    /// 문서 데이터
    @Published var documents: [DocumentMetaData]
    @Published var currentImageIndex: Int = 0
    @Published var toolType: ToolType = .marker

    @Published var maskedImages: [UIImage] = .init()
    @Published var showResultView: Bool = false
    
    var verticalSafeAreaInset: CGFloat

    // MARK: - Computed Properties

    var currentCanvas: DocumentMetaData {
        documents[safe: currentImageIndex]
        ?? DocumentMetaData(image: UIImage(), drawing: PKDrawing())
    }

    var currentImage: UIImage {
        currentCanvas.image
    }

    var currentDrawing: PKDrawing {
        currentCanvas.drawing
    }

    // MARK: - Init

    init(images: [UIImage], verticalSafeAreaInset: CGFloat) {
        self.documents = images.map { DocumentMetaData(image: $0, drawing: PKDrawing()) }
        self.verticalSafeAreaInset = verticalSafeAreaInset
    }

    // MARK: - Interface Methods

    func setToolType(type: ToolType) {
        toolType = type
    }

    func clearCurrentDrawing() {
        guard documents.indices.contains(currentImageIndex) else { return }
        documents[currentImageIndex].drawing = PKDrawing()
    }

    func selectImage(at index: Int) {
        if documents.indices.contains(index) {
            currentImageIndex = index
        }
    }
    
    func getCanvasSize() -> CGSize {
        currentCanvas.calculateCanvasSize(verticalSafeAreaInset: verticalSafeAreaInset)
    }

    @MainActor
    func saveMaskedImages() async {
        let result = await withTaskGroup(of: (Int, UIImage).self) { group in
            for (index, canvas) in documents.enumerated() {
                group.addTask { [self] in
                    let image = self.renderMaskedImage(
                        baseImage: canvas.image,
                        drawing: canvas.drawing,
                        size: canvas.calculateCanvasSize(verticalSafeAreaInset: verticalSafeAreaInset)
                    )
                    return (index, image)
                }
            }
            
            var orderedResults = Array<UIImage?>(repeating: nil, count: documents.count)
            for await (index, image) in group {
                orderedResults[index] = image
            }

            return orderedResults.compactMap { $0 }
        }

        maskedImages = result
        showResultView = true
    }

    // MARK: - Rendering Process

    private func renderMaskedImage(baseImage: UIImage, drawing: PKDrawing, size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = UIScreen.main.scale
        let renderer = UIGraphicsImageRenderer(size: size, format: format)

        return renderer.image { _ in
            baseImage.draw(in: rect)
            drawing.image(from: rect, scale: format.scale).draw(in: rect)
        }
    }
}

// MARK: - ToolType
extension MaskingViewModel {
    enum ToolType: CaseIterable {
        case marker
        case eraser

        var displayName: String {
            switch self {
            case .marker: return "그리기"
            case .eraser: return "지우개"
            }
        }
        
        var iconName: String {
            switch self {
            case .marker: return "brush"
            case .eraser: return "eraser"
            }
        }
    }
}

// MARK: - DocumentMetaData
extension MaskingViewModel {
    /// 문서 이미지를 Masking하기 위한 형태의 MetaData입니다.
    struct DocumentMetaData {
        let image: UIImage
        var drawing: PKDrawing
        
        /// 이미지 크기에 따른 PKCanvas 사이즈
        func calculateCanvasSize(verticalSafeAreaInset: CGFloat) -> CGSize {
            let excludedHeights = verticalSafeAreaInset + 42 + 12 + 71 + 20 + 27 + 22
            let height = UIScreen.main.bounds.height - excludedHeights
            let ratio = imageAspectRatio
            return CGSize(width: height * ratio, height: height)
        }

        /// 이미지 가로 세로 비율
        private var imageAspectRatio: CGFloat {
            guard image.size.height > 0 else { return 1 }
            return image.size.width / image.size.height
        }
    }
}
