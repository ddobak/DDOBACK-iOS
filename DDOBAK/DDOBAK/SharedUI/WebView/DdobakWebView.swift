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
    let tokenStore = KeyChainTokenStore()
    
    weak var listener: DdobakWebViewListener?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(listener: listener)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        
        /// Bridge 구성
        let bridge = DdobakWebBridge(tokenProvider: { tokenStore.accessToken },
                                     listener: listener)
        context.coordinator.bridge = bridge
        
        let config = bridge.makeConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        bridge.attach(webView: webView)
        
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        webView.isHidden = true
        webView.backgroundColor = .mainWhite
        
        bridge.onSavePDF = { [weak coord = context.coordinator] in
            coord?.saveWebViewAsPDF()
        }
        
        if let baseURLString = Bundle.main.object(forInfoDictionaryKey: "WEBVIEW_BASE_URL") as? String,
           let fullURL = URL(string: baseURLString + path) {
            webView.load(URLRequest(url: fullURL))
        } else {
            DDOBakLogger.log("Invalid WEBVIEW_BASE_URL", level: .fault, category: .network)
        }
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // context.coordinator.bridge?.setToken(tokenStore.accessToken)
    }
    
    // MARK: - Coordinator
    final class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
        
        weak var listener: DdobakWebViewListener?
        weak var webView: WKWebView?
        var bridge: DdobakWebBridge?
        
        init(listener: DdobakWebViewListener?) {
            self.listener = listener
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        
        // MARK: - Navigation
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
        
        /// 외부 링크 정책이 필요 시 분기
        func webView(_ webView: WKWebView,
                     decidePolicyFor action: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(.allow)
        }
        
        // MARK: - PDF
        func saveWebViewAsPDF() {
            guard let webView else { return }
            let size = webView.scrollView.contentSize
            let config = WKPDFConfiguration()
            config.rect = CGRect(origin: .zero, size: size)
            
            webView.createPDF(configuration: config) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.listener?.saveWebToPDF(data)
                    
                case .failure(let error):
                    DDOBakLogger.log("PDF generation failed: \(error)", level: .error, category: .webView)
                }
            }
        }
    }
}
