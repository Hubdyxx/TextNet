//
//  HomeViewModel.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 12/10/2025.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchPosts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedPosts = try await PostService.shared.fetchPosts()
            posts = fetchedPosts
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    func clearError() {
        errorMessage = nil
    }
}

