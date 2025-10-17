//
//  String+Ext.swift
//  DDOBAK
//
//  Created by 이건우 on 7/5/25.
//

import Foundation

extension String {
    
}

extension Optional where Wrapped == String {
    func unwrapped(placeholder: String = "") -> String {
        String(self ?? placeholder)
    }
}
