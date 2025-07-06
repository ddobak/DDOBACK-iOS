//
//  SelectDocumentTypeViewModel.swift
//  DDOBAK
//
//  Created by 이건우 on 7/6/25.
//

import SwiftUI

final class SelectDocumentTypeViewModel: ObservableObject {
    
    @Published var selectedDocumentType: DocumentType = .none
}

extension SelectDocumentTypeViewModel {
    enum DocumentType: String, CaseIterable {
        case 근로계약서
        case 임대차계약서
        case none
    }
}
