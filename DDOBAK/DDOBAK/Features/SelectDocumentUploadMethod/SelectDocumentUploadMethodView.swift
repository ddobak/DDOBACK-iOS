//
//  SelectDocumentUploadMethodView.swift
//  DDOBAK
//
//  Created by 이건우 on 6/21/25.
//

import SwiftUI
import PhotosUI

struct SelectDocumentUploadMethodView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @State private var imageSelection: [PhotosPickerItem] = .init()
    @State private var selectedImages: [UIImage] = .init()
    @State private var showPhotosPicker: Bool = false
    @State private var showMaskingView: Bool = false
    
    var body: some View {
        Button("갤러리에서 문서 고르기") {
            showPhotosPicker = true
        }
        .photosPicker(
            isPresented: $showPhotosPicker,
            selection: $imageSelection,
            matching: .images
        )
        .onChange(of: imageSelection) { _, newItems in
            Task {
                selectedImages = .init()
                do {
                    for item in newItems {
                        let image = try await processPickerItem(item: item)
                        selectedImages.append(image)
                    }
                    guard selectedImages.isEmpty == false else { return }
                    Task { @MainActor in
                        showMaskingView = true
                    }
                } catch {
                    // TODO: Alert?
                    print(error.localizedDescription)
                }
            }
        }
        .onAppear {
            imageSelection = .init()
        }
        .navigationDestination(isPresented: $showMaskingView) {
            MaskingView(documentImages: selectedImages, safeAreaInsets: safeAreaInsets)
        }
    }
    
    private func processPickerItem(item: PhotosPickerItem) async throws -> UIImage {
        if let data = try? await item.loadTransferable(type: Data.self),
           let image = UIImage(data: data) {
            return image
        } else {
            throw ProcessImageError.failedToLoadImage
        }
    }
}

#Preview {
    SelectDocumentUploadMethodView()
}
