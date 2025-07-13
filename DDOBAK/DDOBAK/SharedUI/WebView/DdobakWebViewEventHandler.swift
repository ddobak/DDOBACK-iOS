//
//  DdobakWebViewEventHandler.swift
//  DDOBAK
//
//  Created by 이건우 on 7/14/25.
//

import Foundation
import Observation

@Observable
final class DdobakWebViewEventHandler: DdobakWebViewListener {
    var popToRoot: Bool = false
    var analyzeOtherContract: Bool = false
    var savePDF: Bool = false
    var pdfData: Data? = nil
    
    var activityFileURL: URL? = nil
    var showActivityView: Bool = false

    func handleEvent(_ event: DdobakWebViewJavaScriptEventProtocol) {
        switch event {
        case .goHome: popToRoot = true
        case .analyzeOtherContract: analyzeOtherContract = true
        case .savePDF: savePDF = true
        case .none: break
        }
    }
    
    func saveWebToPDF(_ pdfData: Data) {
        let tempFileName = "Ddobak_Analysis_Result\(Date().timeIntervalSince1970).pdf"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(tempFileName)
        
        do {
            try pdfData.write(to: tempURL)
            DDOBakLogger.log("PDF 저장 성공: \(tempURL.path)", level: .info, category: .webView)
            activityFileURL = tempURL
            showActivityView = true
        } catch {
            DDOBakLogger.log("PDF 저장 실패: \(error.localizedDescription)", level: .fault, category: .webView)
        }
    }
}
