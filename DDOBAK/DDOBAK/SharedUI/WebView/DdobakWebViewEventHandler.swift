//
//  DdobakWebViewEventHandler.swift
//  DDOBAK
//
//  Created by 이건우 on 7/14/25.
//

import Combine

final class DdobakWebViewEventHandler: DdobakWebViewListener, ObservableObject {
    @Published var popToRoot: Bool = false
    @Published var analyzeOtherContract: Bool = false
    @Published var savePDF: Bool = false

    func event(_ event: DdobakWebViewJavaScriptEventProtocol) {
        switch event {
        case .goHome: popToRoot = true
        case .analyzeOtherContract: analyzeOtherContract = true
        case .savePDF: savePDF = true
        case .none: break
        }
    }
}
