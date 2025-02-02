//
//  AuthService.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 02/02/2025.
//

import Firebase
import FirebaseAuth

class AuthService {
    
    static let shared = AuthService()
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        
    }
    
    @MainActor
    func createAccount(withEmail email: String, password: String, fullname: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            print("Account created: \(result.user.uid)")
        } catch {
            print("Failed to create an Account: \(error.localizedDescription)")
        }
    }
    
}
