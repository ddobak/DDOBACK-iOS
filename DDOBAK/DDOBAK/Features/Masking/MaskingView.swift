//
//  MaskingView.swift
//  DDOBAK
//
//  Created by 이건우 on 6/21/25.
//

import SwiftUI

struct MaskingView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: MaskingViewModel
    @State private var drawingToolWidth: CGFloat = 10
    
    init(
        documentImages: [UIImage],
        safeAreaInsets: EdgeInsets
    ) {
        let verticalInset = safeAreaInsets.top + safeAreaInsets.bottom
        _viewModel = StateObject(wrappedValue: MaskingViewModel(images: documentImages, verticalSafeAreaInset: verticalInset))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopNavigationBar(
                viewData: .init(
                    shouldShowleadingItem: true,
                    leadingItem: .backButton,
                    shouldShowNavigationTitle: true,
                    navigationTitle: "Masks",
                    shouldShowTrailingItem: true,
                    trailingItem: .text("완료")
                )
            )
            .setAppearance(.dark)
            .onLeadingItemTap {
                dismiss()
            }
            .onTrailingItemTap {
                Task { await viewModel.saveMaskedImages() }
            }
            
            drawingArea
                .background(.gray6)
            
            imageSelector
                .padding(.top, 12)
                .background(Color.mainBlack)
            
            toolbar
                .padding(.top, 20)
                .padding(.bottom, 22)
                .background(Color.mainBlack)
        }
        .navigationBarBackButtonHidden()
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
                viewModel: viewModel,
                drawing: $viewModel.documents[viewModel.currentImageIndex].drawing,
                toolWidth: drawingToolWidth
            )
            .frame(width: viewModel.getCanvasSize().width)
            .id(viewModel.currentImageIndex)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var imageSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 8) {
                ForEach(viewModel.documents.indices, id: \.self) { index in
                    imageThumb(at: index)
                }
            }
            .padding(.leading, 16)
        }
        .frame(height: 71)
    }
    
    private func imageThumb(at index: Int) -> some View {
        Image(uiImage: viewModel.documents[index].image)
            .resizable()
            .scaledToFill()
            .frame(width: 71, height: 71)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .opacity(viewModel.currentImageIndex == index ? 1 : 0.5)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(
                        viewModel.currentImageIndex == index ? .mainBlue : .gray6,
                        lineWidth: 2
                    )
            )
            .onTapGesture {
                viewModel.selectImage(at: index)
            }
    }
    
    private var toolbar: some View {
        HStack(spacing: .zero) {
            Button {
                viewModel.setToolType(type: .marker)
            } label: {
                Image("brush")
            }
            .foregroundStyle(viewModel.toolType == .marker ? .mainWhite : .gray6)
            
            Spacer()
                .frame(width: 12)
            
            Button {
                viewModel.setToolType(type: .eraser)
            } label: {
                Image("eraser")
            }
            .foregroundStyle(viewModel.toolType == .eraser ? .mainWhite : .gray6)
            
            Spacer()
                .frame(width: 30)
            
            Slider(value: $drawingToolWidth, in: 1...30, step: 3)
                .tint(.mainWhite)
        }
        .padding(.horizontal, 20)
        .frame(height: 27)
    }
}
