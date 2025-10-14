//
//  PostCreatorViewModel.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 12/10/2025.
//

import Foundation

@MainActor
class PostCreatorViewModel: ObservableObject {
    @Published var postContent = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    var isPostButtonEnabled: Bool {
        !postContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading
    }
    
    func createPost() async -> Bool {
        guard !postContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Post content cannot be empty"
            return false
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await PostService.shared.createPost(content: postContent)
            postContent = ""
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    func clearPost() {
        postContent = ""
        errorMessage = nil
    }
}

