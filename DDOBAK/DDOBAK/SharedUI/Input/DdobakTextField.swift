//
//  DdobakTextField.swift
//  DDOBAK
//
//  Created by 이건우 on 10/13/25.
//

import SwiftUI

struct DdobakTextField: View {
    
    @Binding private var input: String
    private let placeholder: String
    private var action: (() -> Void)?
    
    init(placeholder: String, input: Binding<String>) {
        self.placeholder = placeholder
        self._input = input
    }
    
    var body: some View {
        TextField(placeholder, text: $input)
            .font(.ddobak(.body1_m16))
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.gray1)
            }
            .overlay(alignment: .trailing) {
                Button {
                    input = ""
                } label: {
                    Image("xmarkCircle")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .padding(.trailing, 16)
            }
    }
}

#Preview {
    @Previewable @State var input: String = ""
    
    DdobakTextField(placeholder: "이름을 입력해주세요", input: $input)
        .padding(.horizontal, 20)
}
