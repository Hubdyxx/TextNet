//
//  RegistrationViewModel.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 02/02/2025.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var fullname = ""
    @Published var username = ""
    
    @MainActor
    func createAccount() async throws {
        try await AuthService.shared.createAccount(
            withEmail: email,
            password: password,
            fullname: fullname,
            username: username
        )
    }
        
}
