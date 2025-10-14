//
//  CommentService.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 12/10/2025.
//

import FirebaseAuth
import FirebaseFirestore

class CommentService {
    static let shared = CommentService()
    private let db = Firestore.firestore()
    
    init() {}
    
    @MainActor
    func createComment(postId: String, content: String) async throws {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            throw CommentError.userNotAuthenticated
        }
        
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw CommentError.emptyContent
        }
        
        let comment = Comment(
            postId: postId,
            authorId: currentUserId,
            content: content.trimmingCharacters(in: .whitespacesAndNewlines),
            timestamp: Timestamp()
        )
        
        let commentData = try Firestore.Encoder().encode(comment)
        try await db.collection("comments").addDocument(data: commentData)
        
        // Create notification for comment (if not own post)
        await createCommentNotification(postId: postId, fromUserId: currentUserId)
    }
    
    func fetchComments(for postId: String) async throws -> [Comment] {
        let snapshot = try await db.collection("comments")
            .whereField("postId", isEqualTo: postId)
            .getDocuments()
        
        let comments = snapshot.documents.compactMap { document in
            try? document.data(as: Comment.self)
        }
        
        // Sort by timestamp (oldest first for comments)
        return comments.sorted { $0.timestamp.dateValue() < $1.timestamp.dateValue() }
    }
    
    func getCommentsCount(for postId: String) async throws -> Int {
        let snapshot = try await db.collection("comments")
            .whereField("postId", isEqualTo: postId)
            .getDocuments()
        
        return snapshot.documents.count
    }
    
    @MainActor
    func likeComment(commentId: String) async throws {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            throw CommentError.userNotAuthenticated
        }
        
        let commentRef = db.collection("comments").document(commentId)
        
        let _ = try await db.runTransaction { transaction, errorPointer in
            let commentDocument: DocumentSnapshot
            do {
                try commentDocument = transaction.getDocument(commentRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard let comment = try? commentDocument.data(as: Comment.self) else {
                let error = NSError(domain: "CommentService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Comment not found"])
                errorPointer?.pointee = error
                return nil
            }
            
            var updatedLikedBy = comment.likedBy
            var updatedLikes = comment.likes
            
            if updatedLikedBy.contains(currentUserId) {
                updatedLikedBy.removeAll { $0 == currentUserId }
                updatedLikes = max(0, updatedLikes - 1)
            } else {
                updatedLikedBy.append(currentUserId)
                updatedLikes += 1
            }
            
            transaction.updateData([
                "likedBy": updatedLikedBy,
                "likes": updatedLikes
            ], forDocument: commentRef)
            
            return nil
        }
    }
    
    @MainActor
    func deleteComment(commentId: String) async throws {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            throw CommentError.userNotAuthenticated
        }
        
        let commentRef = db.collection("comments").document(commentId)
        let commentDocument = try await commentRef.getDocument()
        
        guard let comment = try? commentDocument.data(as: Comment.self) else {
            throw CommentError.commentNotFound
        }
        
        guard comment.authorId == currentUserId else {
            throw CommentError.unauthorized
        }
        
        try await commentRef.delete()
    }
    
    @MainActor
    private func createCommentNotification(postId: String, fromUserId: String) async {
        do {
            // First get the post to find the owner
            let posts = try await PostService.shared.fetchPosts()
            guard let post = posts.first(where: { $0.id == postId }),
                  post.ownerId != fromUserId else { return }
            
            try await NotificationService.shared.createNotification(
                type: .comment,
                fromUserId: fromUserId,
                toUserId: post.ownerId,
                postId: postId
            )
        } catch {
            print("Failed to create comment notification: \(error)")
        }
    }
}

enum CommentError: Error, LocalizedError {
    case userNotAuthenticated
    case emptyContent
    case commentNotFound
    case unauthorized
    
    var errorDescription: String? {
        switch self {
        case .userNotAuthenticated:
            return "User not authenticated"
        case .emptyContent:
            return "Comment content cannot be empty"
        case .commentNotFound:
            return "Comment not found"
        case .unauthorized:
            return "You don't have permission to perform this action"
        }
    }
}

