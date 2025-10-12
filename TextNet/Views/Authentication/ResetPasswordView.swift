//
//  ResetPasswordView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 09/10/2025.
//

import SwiftUI

struct ResetPasswordView: View {
    @StateObject var viewModel = ResetPasswordViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Image("textnet-logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .cornerRadius(15)
                    .padding(.top, 50)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Reset Password")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Enter your email address and we'll send you instructions to reset your password.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                VStack(spacing: 15) {
                    TextField("Enter your email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .modifier(TextFieldModifier())
                        .disabled(viewModel.emailSent)
                    
                    Button {
                        Task {
                            try await viewModel.resetPassword()
                        }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Text(viewModel.emailSent ? "Email Sent!" : "Send Reset Instructions")
                        }
                    }
                    .modifier(SignButtonModifier())
                    .disabled(viewModel.isLoading || viewModel.emailSent)
                }
                .padding(.horizontal)
                
                if viewModel.emailSent {
                    VStack(spacing: 10) {
                        Text("Check your email")
                            .font(.headline)
                            .foregroundColor(.green)
                        
                        Button("Send Another Email") {
                            viewModel.emailSent = false
                        }
                        .font(.footnote)
                        .foregroundColor(.blue)
                    }
                    .padding(.top)
                }
                
                Spacer()
            }
            .navigationTitle("Reset Password")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundColor(.black)
                }
            }
            .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
                Button("OK") {
                    if viewModel.emailSent {
                        dismiss()
                    }
                }
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
}

#Preview {
    ResetPasswordView()
}