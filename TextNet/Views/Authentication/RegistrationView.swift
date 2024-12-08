//
//  RegistrationView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 30/11/2024.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var fullname = ""
    @State private var username = ""
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
                TextField("Enter your Full name", text: $fullname)
                    .modifier(TextFieldModifier())
                
                TextField("Enter your username", text: $username)
                    .modifier(TextFieldModifier())
                
                TextField("Enter your email", text: $email)
                    .modifier(TextFieldModifier())
                
                SecureField("Enter your password", text: $password)
                    .modifier(TextFieldModifier())
            }

                Button {
                    
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
