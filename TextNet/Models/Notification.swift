//
//  Notification.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 12/10/2025.
//

import Foundation
import FirebaseFirestore

struct NotificationModel: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    let type: NotificationType
    let fromUserId: String
    let toUserId: String
    let postId: String?
    let timestamp: Timestamp
    var isRead: Bool = false
    
    var timestampString: String {
        return timestamp.dateValue().timeAgoDisplay()
    }
}

enum NotificationType: String, Codable, CaseIterable {
    case like = "like"
    case follow = "follow"
    case comment = "comment"
    
    var displayText: String {
        switch self {
        case .like:
            return "liked your post"
        case .follow:
            return "started following you"
        case .comment:
            return "commented on your post"
        }
    }
    
    var iconName: String {
        switch self {
        case .like:
            return "heart.fill"
        case .follow:
            return "person.badge.plus"
        case .comment:
            return "bubble.left"
        }
    }
    
    var iconColor: String {
        switch self {
        case .like:
            return "red"
        case .follow:
            return "blue"
        case .comment:
            return "green"
        }
    }
}

