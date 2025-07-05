//
//  MaskingView.swift
//  DDOBAK
//
//  Created by 이건우 on 6/21/25.
//

import SwiftUI

struct MaskingView: View {
    
    @StateObject private var viewModel: MaskingViewModel
    
    init(documentImages: [UIImage]) {
        self._viewModel = StateObject(wrappedValue: MaskingViewModel(images: documentImages))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            drawingArea
            
            imageSelector
            
            toolbar
            
            Spacer()
        }
        .navigationDestination(isPresented: $viewModel.showResultView) {
            ResultView(images: viewModel.maskedImages)
        }
    }
    
    // MARK: - View Components
    
    private var drawingArea: some View {
        ZStack {
            Image(uiImage: viewModel.currentImage)
                .resizable()
                .scaledToFit()

            CanvasRepresentingView(
                drawing: $viewModel.documents[viewModel.currentImageIndex].drawing,
                viewModel: viewModel
            )
            .frame(width: viewModel.canvasSize.width)
            .id(viewModel.currentImageIndex)
        }
        .frame(maxWidth: .infinity)
        .frame(height: UIScreen.main.bounds.height * 0.65)
        .border(.red)
    }
    
    private var imageSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 8) {
                ForEach(viewModel.documents.indices, id: \.self) { index in
                    imageThumb(at: index)
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 90)
    }
    
    private func imageThumb(at index: Int) -> some View {
        Image(uiImage: viewModel.documents[index].image)
            .resizable()
            .scaledToFill()
            .frame(width: 70, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        viewModel.currentImageIndex == index ? Color.blue : Color.clear,
                        lineWidth: 3
                    )
            )
            .onTapGesture {
                viewModel.selectImage(at: index)
            }
    }
    
    private var toolbar: some View {
        HStack(spacing: 16) {
            Button {
                viewModel.setToolType(type: .marker)
            } label: {
                Image("brush")
            }
            .foregroundStyle(viewModel.toolType == .marker ? .red : .blue)
            
            Button {
                viewModel.setToolType(type: .eraser)
            } label: {
                Image("eraser")
            }
            .foregroundStyle(viewModel.toolType == .eraser ? .red : .blue)

            Spacer()

            Button("다음") {
                Task { await viewModel.saveMaskedImages() }
            }
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue)
            )
        }
        .padding(.horizontal, 20)
        .frame(height: 60)
        .border(.red)
    }
}

#Preview {
    MaskingView(documentImages: [UIImage(named: "ss")!])
}
