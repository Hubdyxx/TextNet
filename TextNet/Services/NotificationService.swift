//
//  NotificationService.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 12/10/2025.
//

import FirebaseAuth
import FirebaseFirestore

class NotificationService {
    static let shared = NotificationService()
    private let db = Firestore.firestore()
    
    init() {}
    
    @MainActor
    func createNotification(
        type: NotificationType,
        fromUserId: String,
        toUserId: String,
        postId: String? = nil
    ) async throws {
        // Don't create notification if user is liking their own post
        guard fromUserId != toUserId else { return }
        
        let notification = NotificationModel(
            type: type,
            fromUserId: fromUserId,
            toUserId: toUserId,
            postId: postId,
            timestamp: Timestamp()
        )
        
        let notificationData = try Firestore.Encoder().encode(notification)
        try await db.collection("notifications").addDocument(data: notificationData)
    }
    
    func fetchNotifications(for userId: String) async throws -> [NotificationModel] {
        // Simplified query without ordering to avoid index requirement
        let snapshot = try await db.collection("notifications")
            .whereField("toUserId", isEqualTo: userId)
            .limit(to: 50) // Limit for performance
            .getDocuments()
        
        let notifications = snapshot.documents.compactMap { document in
            try? document.data(as: NotificationModel.self)
        }
        
        // Sort manually by timestamp
        return notifications.sorted { $0.timestamp.dateValue() > $1.timestamp.dateValue() }
    }
    
    func fetchUnreadNotificationsCount(for userId: String) async throws -> Int {
        // Simplified query - filter manually to avoid index requirement
        let snapshot = try await db.collection("notifications")
            .whereField("toUserId", isEqualTo: userId)
            .getDocuments()
        
        let notifications = snapshot.documents.compactMap { document in
            try? document.data(as: NotificationModel.self)
        }
        
        return notifications.filter { !$0.isRead }.count
    }
    
    @MainActor
    func markAsRead(notificationId: String) async throws {
        try await db.collection("notifications")
            .document(notificationId)
            .updateData(["isRead": true])
    }
    
    @MainActor
    func markAllAsRead(for userId: String) async throws {
        // Simplified query to avoid index requirement
        let snapshot = try await db.collection("notifications")
            .whereField("toUserId", isEqualTo: userId)
            .getDocuments()
        
        let batch = db.batch()
        
        for document in snapshot.documents {
            if let notification = try? document.data(as: NotificationModel.self),
               !notification.isRead {
                batch.updateData(["isRead": true], forDocument: document.reference)
            }
        }
        
        try await batch.commit()
    }
    
    @MainActor
    func deleteNotification(notificationId: String) async throws {
        try await db.collection("notifications")
            .document(notificationId)
            .delete()
    }
    
    // Helper method to create like notification
    @MainActor
    func createLikeNotification(fromUserId: String, toUserId: String, postId: String) async throws {
        try await createNotification(
            type: .like,
            fromUserId: fromUserId,
            toUserId: toUserId,
            postId: postId
        )
    }
}

enum NotificationError: Error, LocalizedError {
    case userNotAuthenticated
    case notificationNotFound
    case unauthorized
    
    var errorDescription: String? {
        switch self {
        case .userNotAuthenticated:
            return "User not authenticated"
        case .notificationNotFound:
            return "Notification not found"
        case .unauthorized:
            return "You don't have permission to perform this action"
        }
    }
}

