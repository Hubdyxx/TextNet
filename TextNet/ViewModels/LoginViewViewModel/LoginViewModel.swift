//
//  LoginViewModel.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 05/02/2025.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    @MainActor
    func login() async throws {
        try await AuthService.shared.login(withEmail: email, password: password)
    }
        
}
