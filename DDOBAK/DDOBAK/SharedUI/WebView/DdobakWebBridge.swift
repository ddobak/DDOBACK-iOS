//
//  DdobakWebBridge.swift
//  DDOBAK
//
//  Created by 이건우 on 11/5/25.
//

import WebKit

/// JS <-> Native 브릿지: 스크립트 주입, 메시지 등록/해제, 토큰 담당
final class DdobakWebBridge: NSObject {

    enum Msg: String, CaseIterable {
        case goHome, savePdf, analyzeOther, requestToken
    }
    
    var onSavePDF: (() -> Void)?
    
    private let tokenProvider: () -> String?
    private let contentController = WKUserContentController()
    
    private weak var listener: DdobakWebViewListener?
    private weak var webView: WKWebView?

    init(
        tokenProvider: @escaping () -> String?,
        listener: DdobakWebViewListener?
    ) {
        self.tokenProvider = tokenProvider
        self.listener = listener
        super.init()
        injectTokenScripts()
        registerMessageHandlers()
    }

    deinit {
        Msg.allCases.forEach { contentController.removeScriptMessageHandler(forName: $0.rawValue) }
    }

    func makeConfiguration() -> WKWebViewConfiguration {
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        return config
    }

    func attach(webView: WKWebView) {
        self.webView = webView
    }

    // MARK: - Token
    func setToken(_ token: String?) {
        let value = token.jsEscapedForJS() ?? "null"
        let js = "window.__SET_BRIDGE_TOKEN__(\(value));"
        webView?.evaluateJavaScript(js, completionHandler: nil)
    }

    /// 초기/업데이트 훅 주입
    private func injectTokenScripts() {
        let initial = tokenProvider().jsEscapedForJS() ?? "null"
        let script = """
        // initial
        window.__BRIDGE_TOKEN__ = \(initial);
        
        // runtime token hook
        window.__SET_BRIDGE_TOKEN__ = function(t) {
          if (t === null || t === undefined) {
            window.__BRIDGE_TOKEN__ = null;
          } else {
            window.__BRIDGE_TOKEN__ = String(t);
          }
        };
        """
        let user = WKUserScript(
            source: script,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: true,
            in: .page
        )
        contentController.addUserScript(user)
    }

    // MARK: - Messages

    private func registerMessageHandlers() {
        Msg.allCases.forEach { contentController.add(self, name: $0.rawValue) }
    }
}

// MARK: - WKScriptMessageHandler

extension DdobakWebBridge: WKScriptMessageHandler {
    
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        guard let msg = Msg(rawValue: message.name) else { return }

        switch msg {
        case .savePdf:
            DispatchQueue.main.async { self.onSavePDF?() }
        case .goHome:
            listener?.handleEvent(.init(eventName: msg.rawValue))
        case .analyzeOther:
            listener?.handleEvent(.init(eventName: msg.rawValue))
        case .requestToken:
            setToken(tokenProvider())
        }
    }
}

// MARK: - Helpers

private extension Optional where Wrapped == String {
    
    /// JS 문자열 리터럴/값으로 안전하게 전달. nil -> null
    func jsEscapedForJS() -> String? {
        guard let s = self else { return nil }
        let escaped = s
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "'", with: "\\'")
            .replacingOccurrences(of: "\n", with: "\\n")
        return "'\(escaped)'"
    }
}

extension Notification.Name {
    static let ddobakWebViewSavePDF = Notification.Name("ddobak.webview.savePDF")
}
