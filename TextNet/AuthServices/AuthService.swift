//
//  AuthService.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 02/02/2025.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    
    @Published var userSesssion: FirebaseAuth.User?
    
    static let shared = AuthService()
    
    init() {
        self.userSesssion = Auth.auth().currentUser
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSesssion = result.user
            try await UserService.shared.fetchCurrentUser()
        } catch {
            print("Failed to log in: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func createAccount(withEmail email: String, password: String, fullname: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSesssion = result.user
            try await uploadUserData(withEmail: email, fullname: fullname, username: username, id: result.user.uid)
        } catch {
            print("Failed to create an Account: \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut() // signing out user from firebase
        self.userSesssion = nil //setting user session to nil
        UserService.shared.reset() //set current user object to nil
    }
    
    @MainActor
    private func uploadUserData(
        withEmail email: String,
        fullname: String,
        username: String,
        id: String
    ) async throws {
        let user = User(id: id, fullName: fullname, email: email, username: username)
        guard let userData = try? Firestore.Encoder().encode(user) else { return }
        try await Firestore.firestore().collection("users").document(id).setData(userData)
        UserService.shared.currentUser = user
    }

    
}
