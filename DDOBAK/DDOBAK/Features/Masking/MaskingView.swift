//
//  MaskingView.swift
//  DDOBAK
//
//  Created by 이건우 on 6/21/25.
//

import SwiftUI

struct MaskingView: View {
    
    @Environment(NavigationModel.self) private var navigationModel
    @Environment(ContractAnalysisFlowModel.self) private var contractAnalysisFlowModel
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: MaskingViewModel
    @State private var drawingToolWidth: CGFloat = 15
    @State private var drawingAreaSize: CGSize = .zero
    
    // MARK: DragGesture State Value
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var isZooming: Bool = false
    
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
                    navigationTitle: "마스킹",
                    shouldShowTrailingItem: true,
                    trailingItem: .text("완료")
                )
            )
            .setAppearance(.dark)
            .onLeadingItemTap {
                dismiss()
            }
            .onTrailingItemTap {
                HapticManager.shared.selectionChanged()
                Task {
                    guard let selectedContractType = contractAnalysisFlowModel.selectedContractType else {
                        return
                    }
                    let maskedImages = await viewModel.maskingImages()
                    await viewModel.requestOCR(maskedImages: maskedImages,
                                               contractType: selectedContractType)
                }
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
        .loadingOverlay(isLoading: $viewModel.isLoading)
        .alert(viewModel.errorMessage ?? "OCR 과정에서 문제가 발생했어요.", isPresented: $viewModel.showErrorAlert) {
            Button("확인", role: .cancel) {
                viewModel.showErrorAlert = false
            }
        }
        .onChange(of: viewModel.isOcrSuccessful) { _, isOcrSuccessful in
            if let ocrContractId = viewModel.ocrContractId {
                navigationModel.push(.checkOcrResult(contractId: ocrContractId))
            }
        }
        .onChange(of: viewModel.currentImageIndex) { _, _ in
            /// 선택된 이미지 변경 시 `scale` 및 `offset` 초기화
            scale = 1
            offset = .zero
        }
    }
}

// MARK: Gesture
extension MaskingView {
    
    var magnifyGesture: some Gesture {
        MagnifyGesture()
            .onChanged { value in
                /// 최소 축소 비율 1로 설정
                scale = max(1, lastScale * value.magnification)
            }
            .onEnded { _ in
                /// `scale`비율로 `zoom` 상태 판단
                lastScale = scale
                isZooming = lastScale > 1
                
                /// `zooming` 상태에 따라 `penGesture`를 위해  `marker` 기능 해제
                let toolTypeByZoomState: MaskingViewModel.ToolType = isZooming ? .disabled : .marker
                viewModel.setToolType(type: toolTypeByZoomState)
                
                /// 최소 비율로 왔을 때 `offset` 초기화
                if lastScale == 1 {
                    offset = .zero
                    lastOffset = .zero
                }
            }
    }
    
    var panGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                /// 확대 중이면서 도구가 비활성화된 경우에만 `PanGesture` 허용
                guard isZooming == true && viewModel.toolType == .disabled else { return }
                
                /// 확대된 캔버스 크기와 표시 영역 `drawingArea`의 차이 계산
                let sizeGap: CGSize = .init(
                    width: viewModel.getCanvasSize().width * lastScale - drawingAreaSize.width,
                    height: viewModel.getCanvasSize().height * lastScale - drawingAreaSize.height
                )
                /// 이동 가능한 최대 오프셋(중앙 기준): 좌우/상하로 sizeGap의 절반만큼 제한
                /// 좌우/상하로 sizeGap의 절반만큼 제한
                let panGestureOffsetLimit: CGSize = .init(
                    width: max(sizeGap.width, 0) / 2,
                    height: max(sizeGap.height, 0) / 2
                )

                /// 기존 `offset`에 드래그 변화를 더해 새로운 위치 계산
                let rawOffset = CGSize(
                    width: lastOffset.width + value.translation.width,
                    height: lastOffset.height + value.translation.height
                )
                /// 확대 비율을 고려하여 제한된 오프셋 계산 (clamp)
                /// x y축 양수 음수 처리
                let limitedScaledOffset = CGSize(
                    width: min(max(rawOffset.width * scale, -panGestureOffsetLimit.width), panGestureOffsetLimit.width),
                    height: min(max(rawOffset.height * scale, -panGestureOffsetLimit.height), panGestureOffsetLimit.height)
                )

                /// 실제 적용할 오프셋은 스케일을 다시 나눠 원래 좌표계로 복원
                offset = CGSize(
                    width: limitedScaledOffset.width / scale,
                    height: limitedScaledOffset.height / scale
                )

                /// 제한 값 벗어나면 `PanGesture` 적용하지 않고 return
                if rawOffset != limitedScaledOffset {
                    return
                }
            }
            .onEnded { _ in
                guard scale > 1 else { return }
                lastOffset = offset
            }
    }
}

// MARK: - View Components
extension MaskingView {
    private var drawingArea: some View {
        ZStack {
            Image(uiImage: viewModel.currentImage)
                .resizable()
                .scaledToFit()
                .offset(offset)
                .scaleEffect(scale)
            
            CanvasRepresentingView(
                viewModel: viewModel,
                drawing: $viewModel.documents[viewModel.currentImageIndex].drawing,
                toolWidth: drawingToolWidth
            )
            .frame(width: viewModel.getCanvasSize().width)
            .allowsHitTesting(viewModel.toolType != .disabled)
            .id(viewModel.currentImageIndex)
            .offset(offset)
            .scaleEffect(scale)
        }
        .frame(maxWidth: .infinity)
        .clipped()
        .onReadSize {
            drawingAreaSize = $0
        }
        .simultaneousGesture(magnifyGesture)
        .simultaneousGesture(panGesture)
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
                HapticManager.shared.selectionChanged()
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
                .onChange(of: drawingToolWidth) { _, _ in
                    HapticManager.shared.selectionChanged()
                }
        }
        .padding(.horizontal, 20)
        .frame(height: 27)
    }
}
