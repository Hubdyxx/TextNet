//
//  SearchViewModel.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 09/02/2025.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var users = [User]()
    
    init(){
        Task { try await fetchUsers() }
    }
    @MainActor
    private func fetchUsers() async throws {
        self.users = try await UserService.fetchUsers()
    }
}
