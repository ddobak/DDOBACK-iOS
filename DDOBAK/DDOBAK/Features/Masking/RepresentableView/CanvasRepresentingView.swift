//
//  CanvasRepresentingView.swift
//  DDOBAK
//
//  Created by 이건우 on 6/21/25.
//

import SwiftUI
import PencilKit

struct CanvasRepresentingView: UIViewRepresentable {
    @ObservedObject var viewModel: MaskingViewModel
    @Binding var drawing: PKDrawing
    var toolWidth: CGFloat

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: CanvasRepresentingView

        init(_ parent: CanvasRepresentingView) {
            self.parent = parent
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            DispatchQueue.main.async {
                self.parent.drawing = canvasView.drawing
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.delegate = context.coordinator
        canvas.drawing = drawing
        canvas.drawingPolicy = .anyInput
        canvas.backgroundColor = .clear
        canvas.isOpaque = false
        if let tool = pkToolType() {
            canvas.tool = tool
        }
        
        return canvas
    }

    func updateUIView(_ canvas: PKCanvasView, context: Context) {
        if let tool = pkToolType() {
            canvas.tool = tool
        }

        DispatchQueue.main.async {
            if canvas.drawing != drawing {
                canvas.drawing = drawing
            }
        }
    }

    private func pkToolType() -> PKTool? {
        switch viewModel.toolType {
        case .marker:
            return PKInkingTool(.marker, color: .black, width: toolWidth)
            
        case .eraser:
            return PKEraserTool(.bitmap, width: toolWidth)
            
        case .disabled:
            return nil
        }
    }
}
