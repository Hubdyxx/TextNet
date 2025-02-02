//
//  RegistrationView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 30/11/2024.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel = RegistrationViewModel()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            
            Image("textnet-logo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .cornerRadius(20)
                .padding(.vertical,70)
            
            VStack {
                TextField("Enter your Full name", text: $viewModel.fullname)
                    .modifier(TextFieldModifier())
                
                TextField("Enter your username", text: $viewModel.username)
                    .modifier(TextFieldModifier())
                
                TextField("Enter your email", text: $viewModel.email)
                    .modifier(TextFieldModifier())
                
                SecureField("Enter your password", text: $viewModel.password)
                    .modifier(TextFieldModifier())
            }

                Button {
                    Task { try await viewModel.createAccount()}
                } label: {
                    Text("Sign up")
                        .modifier(SignButtonModifier())
                }
                
                Spacer()
                
                Divider()
                
                Button{
                    dismiss()
                } label: {
                    HStack{
                        Text("Already have an account?")
                        Text("Sign in!")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.black)
                    .font(.system(size: 18))
                    .font(.footnote)
                }
                .padding(.vertical)
            
            
        }
    }
}

#Preview {
    RegistrationView()
}
