//
//  Array+Ext.swift
//  DDOBAK
//
//  Created by 이건우 on 7/5/25.
//

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
