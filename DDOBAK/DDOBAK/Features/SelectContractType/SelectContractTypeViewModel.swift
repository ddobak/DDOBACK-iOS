//
//  SelectContractTypeViewModel.swift
//  DDOBAK
//
//  Created by 이건우 on 7/6/25.
//

import SwiftUI

final class SelectContractTypeViewModel: ObservableObject {
    
    @Published var selectedContractType: ContractType = .none
}
