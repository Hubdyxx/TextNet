//
//  CommentViewModel.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 12/10/2025.
//

import Foundation

@MainActor
class CommentViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var commentsCount = 0
    
    let postId: String
    
    init(postId: String) {
        self.postId = postId
    }
    
    func fetchComments() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedComments = try await CommentService.shared.fetchComments(for: postId)
            comments = fetchedComments
            commentsCount = fetchedComments.count
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    func fetchCommentsCount() async {
        do {
            let count = try await CommentService.shared.getCommentsCount(for: postId)
            commentsCount = count
        } catch {
            print("Failed to fetch comments count: \(error)")
        }
    }
    
    func addComment(_ comment: Comment) {
        comments.append(comment)
        commentsCount = comments.count
    }
    
    func deleteComment(_ comment: Comment) async {
        guard let commentId = comment.id else { return }
        
        do {
            try await CommentService.shared.deleteComment(commentId: commentId)
            
            // Remove from local state
            comments.removeAll { $0.id == commentId }
            commentsCount = comments.count
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func clearError() {
        errorMessage = nil
    }
}

