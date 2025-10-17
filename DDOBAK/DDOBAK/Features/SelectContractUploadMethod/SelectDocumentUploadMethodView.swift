//
//  SelectContractUploadMethodView.swift
//  DDOBAK
//
//  Created by 이건우 on 6/21/25.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct SelectContractUploadMethodView: View {
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(NavigationModel.self) private var navigationModel
    
    @State private var imageSelection: [PhotosPickerItem] = .init()
    @State private var selectedImages: [UIImage] = .init()
    @State private var showPhotosPicker: Bool = false
    @State private var showMaskingView: Bool = false
    @State private var showPDFPicker: Bool = false
    
    @State private var alertErrorDescription: String?
    @State private var showErrorAlert: Bool = false
    
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
        .alert(alertErrorDescription ?? "이미지 처리에 문제가 발생했어요", isPresented: $showErrorAlert) {
            Button("확인", role: .cancel) { }
        }
        .photosPicker(
            isPresented: $showPhotosPicker,
            selection: $imageSelection,
            matching: .images
        )
        .onChange(of: imageSelection) { _, newItems in
            handleImageSelection(items: newItems)
        }
        .fileImporter(
            isPresented: $showPDFPicker,
            allowedContentTypes: [.pdf],
            allowsMultipleSelection: false
        ) { result in
            handlePDFSelectionResult(result: result)
        }
        .navigationDestination(isPresented: $showMaskingView) {
            MaskingView(documentImages: selectedImages, safeAreaInsets: safeAreaInsets)
                .navigationBarBackButtonHidden()
        }
    }
}

// MARK: Views
extension SelectContractUploadMethodView {
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
                showPDFPicker = true
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
                imageSelection = .init()
                showPhotosPicker = true
            }
        }
    }
}

// MARK: Methods
extension SelectContractUploadMethodView {
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
                alertErrorDescription = error.localizedDescription
                showErrorAlert = true
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
    
    
    private func handlePDFSelectionResult(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }

            guard url.startAccessingSecurityScopedResource() else {
                alertErrorDescription = "PDF 파일에 접근할 수 없어요."
                showErrorAlert = true
                return
            }

            Task {
                defer { url.stopAccessingSecurityScopedResource() }

                do {
                    let images = await convertPDFToImages(url: url)
                    guard images.isEmpty == false else {
                        alertErrorDescription = "PDF에서 이미지를 추출할 수 없어요."
                        showErrorAlert = true
                        return
                    }
                    await MainActor.run {
                        selectedImages = images
                        showMaskingView = true
                    }
                }
            }

        case .failure(let error):
            alertErrorDescription = error.localizedDescription
            showErrorAlert = true
        }
    }
    
    private func convertPDFToImages(url: URL) async -> [UIImage] {
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("❌ PDF 파일이 존재하지 않습니다: \(url)")
            return []
        }

        guard let document = CGPDFDocument(url as CFURL) else {
            print("❌ CGPDFDocument 초기화 실패: \(url)")
            return []
        }

        guard document.numberOfPages > 0 else {
            print("❌ PDF 페이지 없음")
            return []
        }

        var images: [UIImage] = []
        for pageIndex in 1...document.numberOfPages {
            guard let page = document.page(at: pageIndex) else {
                print("⚠️ 페이지 \(pageIndex) 를 불러오지 못했습니다")
                continue
            }
            let pageRect = page.getBoxRect(.mediaBox)
            let renderer = UIGraphicsImageRenderer(size: pageRect.size)
            let image = renderer.image { ctx in
                UIColor.white.set()
                ctx.fill(pageRect)
                ctx.cgContext.translateBy(x: 0, y: pageRect.size.height)
                ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
                ctx.cgContext.drawPDFPage(page)
            }
            images.append(image)
        }

        print("✅ 변환된 이미지 수: \(images.count)")
        return images
    }
}

#Preview {
    SelectContractUploadMethodView()
        .environment(NavigationModel())
}
