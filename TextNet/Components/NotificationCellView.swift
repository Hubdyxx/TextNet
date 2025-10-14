//
//  NotificationCellView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 12/10/2025.
//

import SwiftUI

struct NotificationCellView: View {
    let notification: NotificationModel
    @State private var fromUser: User?
    @State private var post: Post?
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Profile picture
            AsyncImage(url: URL(string: fromUser?.profileImageUrl ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .foregroundColor(.gray)
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    // Notification icon
                    Image(systemName: notification.type.iconName)
                        .foregroundColor(colorForType(notification.type.iconColor))
                        .font(.caption)
                    
                    // Username and action text
                    Text("\(fromUser?.username ?? "Unknown") \(notification.type.displayText)")
                        .font(.footnote)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    // Timestamp
                    Text(notification.timestampString)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // Post content preview (for post-related notifications)
                if let post = post, notification.type == .like || notification.type == .comment {
                    Text(post.content)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .padding(.top, 2)
                }
            }
            
            // Unread indicator
            if !notification.isRead {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(notification.isRead ? Color.clear : Color.blue.opacity(0.05))
        .task {
            await fetchUserAndPost()
        }
    }
    
    private func colorForType(_ colorString: String) -> Color {
        switch colorString {
        case "red":
            return .red
        case "blue":
            return .blue
        case "green":
            return .green
        default:
            return .gray
        }
    }
    
    private func fetchUserAndPost() async {
        // Fetch the user who triggered the notification
        do {
            let users = try await UserService.fetchUsers()
            if let user = users.first(where: { $0.id == notification.fromUserId }) {
                fromUser = user
            } else if let currentUser = UserService.shared.currentUser,
                      currentUser.id == notification.fromUserId {
                fromUser = currentUser
            }
        } catch {
            print("Failed to fetch notification user: \(error)")
        }
        
        // Fetch the post if this is a post-related notification
        if let postId = notification.postId {
            do {
                let posts = try await PostService.shared.fetchPosts()
                post = posts.first { $0.id == postId }
            } catch {
                print("Failed to fetch notification post: \(error)")
            }
        }
    }
}

#Preview {
    NotificationCellView(
        notification: NotificationModel(
            type: .like,
            fromUserId: "user1",
            toUserId: "user2",
            postId: "post1",
            timestamp: .init()
        )
    )
}

