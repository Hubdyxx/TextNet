//
//  CommentCreatorViewModel.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 12/10/2025.
//

import Foundation

@MainActor
class CommentCreatorViewModel: ObservableObject {
    @Published var commentContent = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    let postId: String
    
    init(postId: String) {
        self.postId = postId
    }
    
    var isCommentButtonEnabled: Bool {
        !commentContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading
    }
    
    func createComment() async -> Bool {
        guard !commentContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Comment content cannot be empty"
            return false
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await CommentService.shared.createComment(postId: postId, content: commentContent)
            commentContent = ""
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    func clearComment() {
        commentContent = ""
        errorMessage = nil
    }
}

