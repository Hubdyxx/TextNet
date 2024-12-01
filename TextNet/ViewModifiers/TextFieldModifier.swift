//
//  TextFieldModifier.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 30/11/2024.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal,30)
    }
}
