//
//  CanvasRepresentingView.swift
//  DDOBAK
//
//  Created by 이건우 on 6/21/25.
//

import SwiftUI
import PencilKit

struct CanvasRepresentingView: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    @ObservedObject var viewModel: MaskingViewModel

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
        canvas.tool = pkToolType()
        canvas.drawingPolicy = .anyInput
        canvas.backgroundColor = .clear
        canvas.isOpaque = false
        return canvas
    }

    func updateUIView(_ canvas: PKCanvasView, context: Context) {
        canvas.tool = pkToolType()

        DispatchQueue.main.async {
            if canvas.drawing != drawing {
                canvas.drawing = drawing
            }
        }
    }

    private func pkToolType() -> PKTool {
        switch viewModel.toolType {
        case .marker:
            return PKInkingTool(.marker, color: .black, width: 20)
        case .eraser:
            return PKEraserTool(.bitmap, width: 30)
        }
    }
}
