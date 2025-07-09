//
//  Error+Ext.swift
//  DDOBAK
//
//  Created by 이건우 on 7/10/25.
//

import Foundation

extension Error {
    func handleDecodingError() {
        if let decodingError = self as? DecodingError {
            switch decodingError {
            case .typeMismatch(let type, let context):
                DDOBakLogger.log("Type mismatch for type: \(type), context: \(context)", level: .error, category: .network)
                
            case .valueNotFound(let value, let context):
                DDOBakLogger.log("Value not found: \(value), context: \(context)", level: .error, category: .network)
                
            case .keyNotFound(let key, let context):
                DDOBakLogger.log("Key not found: \(key), context: \(context)", level: .error, category: .network)
                
            case .dataCorrupted(let context):
                DDOBakLogger.log("Data corrupted, context: \(context)", level: .error, category: .network)
                
            default:
                DDOBakLogger.log("Default Decoding error: \(decodingError)", level: .error, category: .network)
                
            }
        } else {
            DDOBakLogger.log("Unexpected Error: \(self)", level: .error, category: .network)
        }
    }
}
