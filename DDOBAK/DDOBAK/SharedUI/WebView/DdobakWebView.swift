//
//  DdobakWebView.swift
//  DDOBAK
//
//  Created by 이건우 on 7/13/25.
//

import SwiftUI
import WebKit

public protocol DdobakWebViewListener: AnyObject {
    func handleEvent(_ event: DdobakWebViewJavaScriptEventProtocol)
    func saveWebToPDF(_ pdfData: Data)
}

struct DdobakWebView: UIViewRepresentable {
    
    let path: String
    weak var listener: DdobakWebViewListener?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(listener: listener)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "goHome")
        contentController.add(context.coordinator, name: "savePdf")
        contentController.add(context.coordinator, name: "analyzeOther")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        webView.isHidden = true
        webView.backgroundColor = .mainWhite
        
        if let baseURLString = Bundle.main.object(forInfoDictionaryKey: "WEBVIEW_BASE_URL") as? String,
           let fullURL = URL(string: baseURLString + path) {
            webView.load(URLRequest(url: fullURL))
        } else {
            DDOBakLogger.log("Invalid WEBVIEW_BASE_URL", level: .fault, category: .network)
        }
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        
    }
    
    class Coordinator: NSObject, WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate {
        
        weak var listener: DdobakWebViewListener?
        var webView: WKWebView?
        
        init(listener: DdobakWebViewListener?) {
            self.listener = listener
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            DDOBakLogger.log("didReceive message: \(message.name)", level: .debug, category: .webView)
            if message.name == "savePdf" {
                saveWebViewAsPDF()
            } else {
                listener?.handleEvent(.init(eventName: message.name))
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.webView = webView
            
            webView.isHidden = false
            let zoomDisableScript = """
                var meta = document.createElement('meta');
                meta.name = 'viewport';
                meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
                document.getElementsByTagName('head')[0].appendChild(meta);
            """
            webView.evaluateJavaScript(zoomDisableScript, completionHandler: nil)
        }
        
        private func saveWebViewAsPDF() {
            guard let webView else { return }
            
            let config = WKPDFConfiguration()
            config.rect = webView.bounds
            
            webView.createPDF(configuration: config) { result in
                switch result {
                case .success(let data):
                    self.listener?.saveWebToPDF(data)
                case .failure(let error):
                    DDOBakLogger.log("PDF generation failed: \(error)", level: .error, category: .webView)
                }
            }
        }
    }
}

#Preview {
    DdobakWebView(path: "/test")
}
