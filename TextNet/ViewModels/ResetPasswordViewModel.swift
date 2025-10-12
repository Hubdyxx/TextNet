//
//  ResetPasswordViewModel.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 09/10/2025.
//

import Foundation

@MainActor
class ResetPasswordViewModel: ObservableObject {
    @Published var email = ""
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var isLoading = false
    @Published var emailSent = false
    
    func resetPassword() async throws {
        guard !email.isEmpty else {
            showError(title: "Error", message: "Please enter your email address")
            return
        }
        
        guard isValidEmail(email) else {
            showError(title: "Invalid Email", message: "Please enter a valid email address")
            return
        }
        
        isLoading = true
        
        do {
            try await AuthService.shared.resetPassword(withEmail: email)
            showSuccess()
        } catch {
            showError(title: "Error", message: "Failed to send reset email. Please try again.")
        }
        
        isLoading = false
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func showError(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    private func showSuccess() {
        alertTitle = "Email Sent"
        alertMessage = "Password reset instructions have been sent to your email address."
        emailSent = true
        showAlert = true
    }
}