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
    
    @Published var ocrContractId: String?
    @Published var isOcrSuccessful: Bool = false
    @Published var errorMessage: String?
    @Published var showErrorAlert: Bool = false
    @Published var isLoading: Bool = false
    
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
    func maskingImages() async -> [UIImage] {
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

        return result
    }
    
    @MainActor
    func requestOCR(maskedImages: [UIImage], contractType: ContractType) async {
        isLoading = true
        defer { isLoading = false }

        do {
            // 이미지 파일 파트 생성
            let fileParts: [MultipartPart] = maskedImages.enumerated().compactMap { index, image in
                guard let data = image.jpegData(compressionQuality: 1) else {
                    fatalError()
                }
                return MultipartPart(
                    name: "files",
                    filename: "image\(index).jpeg",
                    mimeType: "image/jpeg",
                    data: data
                )
            }

            // contractType 필드 파트 생성
            let contractTypePart = MultipartPart(
                name: "contractType",
                data: Data(contractType.requestParameter.utf8)
            )

            // 파트 병합 후 Request
            let parts = fileParts + [contractTypePart]
            let response: ResponseDTO<OCRContractResult> = try await APIClient.shared.requestMultipart(
                path: "/contract/ocr",
                parts: parts
            )
            
            // 에러 처리
            guard response.success == true else {
                errorMessage = response.userMessage
                showErrorAlert = true
                return
            }
            
            if let ocrContractId = response.data?.contractId {
                self.ocrContractId = ocrContractId
                isOcrSuccessful = response.data?.ocrStatus == "success"
                DDOBakLogger.log(ocrContractId, level: .info, category: .viewModel)
            }
            
        } catch {
            errorMessage = error.localizedDescription
        }
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
