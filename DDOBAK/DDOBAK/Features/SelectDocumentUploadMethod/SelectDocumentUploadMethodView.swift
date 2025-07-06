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
    @Environment(NavigationModel.self) private var navigationModel
    
    @State private var imageSelection: [PhotosPickerItem] = .init()
    @State private var selectedImages: [UIImage] = .init()
    @State private var showPhotosPicker: Bool = false
    @State private var showMaskingView: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            TopNavigationBar(
                viewData: .init(
                    shouldShowleadingItem: true,
                    leadingItem: .backButton,
                    shouldShowNavigationTitle: false,
                    navigationTitle: nil,
                    shouldShowTrailingItem: false,
                    trailingItem: .none
                )
            )
            .setAppearance(.light)
            .onLeadingItemTap {
                navigationModel.pop()
            }
            .zIndex(1)
            
            // MARK: View Area
            VStack(spacing: .zero) {
                DdobakPageTitle(
                    viewData: .init(
                        title: "계약서를 어떻게 불러올까요?",
                        subtitleType: .normal("또박이는 사진이든 PDF든 상관없어요!\n계약서만 잘 보이면, 독소 조항을 또박또박 분석해드릴게요."),
                        alignment: .leading
                    )
                )
                .padding(.top, 36)
                
                Spacer()
                
                guidelineImageSection
                
                Spacer()
                    .frame(height: 30)
                
                methodSelectButtons
                    .padding(.bottom, 22)
            }
            .padding(.top, TopNavigationBarAppearance.topNavigationBarHeight)
        }
        .background(.mainWhite)
        .photosPicker(
            isPresented: $showPhotosPicker,
            selection: $imageSelection,
            matching: .images
        )
        .onChange(of: imageSelection) { _, newItems in
            handleImageSelection(items: newItems)
        }
        .onAppear {
            imageSelection = .init()
        }
        .navigationDestination(isPresented: $showMaskingView) {
            MaskingView(documentImages: selectedImages, safeAreaInsets: safeAreaInsets)
        }
    }
}

// MARK: Views
extension SelectDocumentUploadMethodView {
    private var guidelineImageSection: some View {
        VStack(spacing: .zero) {
            Image("ddobakSelect")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 20)
            
            Image("photoGuideline")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 20)
                .buttonShadow()
        }
    }
    
    private var methodSelectButtons: some View {
        VStack(spacing: 8) {
            DdobakButton(
                viewData: .init(
                    title: "PDF 업로드하기",
                    buttonType: .white,
                    isEnabled: true,
                    isLoading: false
                )
            )
            .onButtonTap {
                
            }
            
            DdobakButton(
                viewData: .init(
                    title: "사진 선택하기",
                    buttonType: .white,
                    isEnabled: true,
                    isLoading: false
                )
            )
            .onButtonTap {
                showPhotosPicker = true
            }
        }
    }
}

// MARK: Methods
extension SelectDocumentUploadMethodView {
    private func handleImageSelection(items: [PhotosPickerItem]) {
        Task {
            selectedImages = .init()
            do {
                for item in items {
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
        .environment(NavigationModel())
}
