//
//  ActivityView.swift
//  DDOBAK
//
//  Created by 이건우 on 7/14/25.
//

import UIKit
import SwiftUI

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let vc = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) { }
}
