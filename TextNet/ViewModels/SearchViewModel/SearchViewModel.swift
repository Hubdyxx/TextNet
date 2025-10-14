//
//  SearchViewModel.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 09/02/2025.
//

import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var users = [User]()
    @Published var filteredUsers = [User]()
    @Published var searchText = ""
    @Published var isLoading = false
    
    private var allUsers = [User]()
    
    init(){
        Task { try await fetchUsers() }
    }
    
    private func fetchUsers() async throws {
        isLoading = true
        do {
            let fetchedUsers = try await UserService.fetchUsers()
            allUsers = fetchedUsers
            users = fetchedUsers
            filteredUsers = fetchedUsers
            isLoading = false
        } catch {
            isLoading = false
            throw error
        }
    }
    
    func updateSearchText(_ text: String) {
        searchText = text
        filterUsers()
    }
    
    private func filterUsers() {
        if searchText.isEmpty {
            filteredUsers = allUsers
        } else {
            filteredUsers = allUsers.filter { user in
                user.username.localizedCaseInsensitiveContains(searchText) ||
                user.fullName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func refreshUsers() async {
        do {
            try await fetchUsers()
        } catch {
            print("Failed to refresh users: \(error)")
        }
    }
}
