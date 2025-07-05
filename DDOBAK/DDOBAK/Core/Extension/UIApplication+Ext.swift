//
//  UIApplication+Ext.swift
//  DDOBAK
//
//  Created by 이건우 on 7/5/25.
//

import UIKit

extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
