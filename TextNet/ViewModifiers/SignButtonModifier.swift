//
//  SignButtonModifier.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 01/12/2024.
//

import SwiftUI

struct SignButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(width: 330, height: 50)
            .background(.black)
            .cornerRadius(10)
            .padding(.top)
    }
}
