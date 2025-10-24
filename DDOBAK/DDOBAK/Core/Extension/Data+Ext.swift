//
//  Data+Ext.swift
//  DDOBAK
//
//  Created by 이건우 on 10/12/25.
//

import Foundation

extension Data {
    var prettyJson: String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(self) else { return nil }
        return String(data: data, encoding: .utf8) ?? nil
    }
}
