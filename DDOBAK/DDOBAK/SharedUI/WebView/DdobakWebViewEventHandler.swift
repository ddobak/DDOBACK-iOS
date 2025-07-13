//
//  DdobakWebViewEventHandler.swift
//  DDOBAK
//
//  Created by 이건우 on 7/14/25.
//

import Observation

@Observable
final class DdobakWebViewEventHandler: DdobakWebViewListener {
    var popToRoot: Bool = false
    var analyzeOtherContract: Bool = false
    var savePDF: Bool = false

    func event(_ event: DdobakWebViewJavaScriptEventProtocol) {
        switch event {
        case .goHome: popToRoot = true
        case .analyzeOtherContract: analyzeOtherContract = true
        case .savePDF: savePDF = true
        case .none: break
        }
    }
}
