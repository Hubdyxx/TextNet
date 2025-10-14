//
//  PostService.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 12/10/2025.
//

import FirebaseAuth
import FirebaseFirestore

class PostService {
    static let shared = PostService()
    private let db = Firestore.firestore()
    
    init() {}
    
    @MainActor
    func createPost(content: String) async throws {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            throw PostError.userNotAuthenticated
        }
        
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw PostError.emptyContent
        }
        
        let post = Post(
            ownerId: currentUserId,
            content: content.trimmingCharacters(in: .whitespacesAndNewlines),
            timestamp: Timestamp()
        )
        
        let postData = try Firestore.Encoder().encode(post)
        try await db.collection("posts").addDocument(data: postData)
    }
    
    func fetchPosts() async throws -> [Post] {
        let snapshot = try await db.collection("posts")
            .order(by: "timestamp", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            try? document.data(as: Post.self)
        }
    }
    
    func fetchUserPosts(userId: String) async throws -> [Post] {
        let snapshot = try await db.collection("posts")
            .whereField("ownerId", isEqualTo: userId)
            .order(by: "timestamp", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            try? document.data(as: Post.self)
        }
    }
    
    @MainActor
    func likePost(postId: String) async throws {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            throw PostError.userNotAuthenticated
        }
        
        let postRef = db.collection("posts").document(postId)
        
        // First get the post to check owner and current like status
        let postDocument = try await postRef.getDocument()
        guard let post = try? postDocument.data(as: Post.self) else {
            throw PostError.postNotFound
        }
        
        let isCurrentlyLiked = post.likedBy.contains(currentUserId)
        
        let _ = try await db.runTransaction { transaction, errorPointer in
            let postDocument: DocumentSnapshot
            do {
                try postDocument = transaction.getDocument(postRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard let post = try? postDocument.data(as: Post.self) else {
                let error = NSError(domain: "PostService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Post not found"])
                errorPointer?.pointee = error
                return nil
            }
            
            var updatedLikedBy = post.likedBy
            var updatedLikes = post.likes
            
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
            ], forDocument: postRef)
            
            return nil
        }
        
        // Create notification if the post was liked (not unliked) and it's not the user's own post
        if !isCurrentlyLiked && currentUserId != post.ownerId {
            do {
                try await NotificationService.shared.createLikeNotification(
                    fromUserId: currentUserId,
                    toUserId: post.ownerId,
                    postId: postId
                )
            } catch {
                print("Failed to create like notification: \(error)")
                // Don't throw error here as the main like action succeeded
            }
        }
    }
    
    @MainActor
    func deletePost(postId: String) async throws {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            throw PostError.userNotAuthenticated
        }
        
        let postRef = db.collection("posts").document(postId)
        let postDocument = try await postRef.getDocument()
        
        guard let post = try? postDocument.data(as: Post.self) else {
            throw PostError.postNotFound
        }
        
        guard post.ownerId == currentUserId else {
            throw PostError.unauthorized
        }
        
        try await postRef.delete()
    }
}

enum PostError: Error, LocalizedError {
    case userNotAuthenticated
    case emptyContent
    case postNotFound
    case unauthorized
    
    var errorDescription: String? {
        switch self {
        case .userNotAuthenticated:
            return "User not authenticated"
        case .emptyContent:
            return "Post content cannot be empty"
        case .postNotFound:
            return "Post not found"
        case .unauthorized:
            return "You don't have permission to perform this action"
        }
    }
}

