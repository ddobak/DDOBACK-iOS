//
//  DdobakWebViewJavaScriptEventProtocol.swift
//  DDOBAK
//
//  Created by 이건우 on 7/13/25.
//

/// 웹에서 발생하는 이벤트 정의
public enum DdobakWebViewJavaScriptEventProtocol {
    case goHome
    case analyzeOtherContract
    case savePDF
    case none
    
    init(eventName: String) {
        switch eventName {
        case "goHome":
            self = .goHome
            
        case "analyzeOtherContract":
            self = .analyzeOtherContract
            
        case "savePDF":
            self = .savePDF
            
        default:
            self = .none
        }
    }
}
