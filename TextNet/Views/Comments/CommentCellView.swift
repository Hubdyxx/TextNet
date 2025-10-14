//
//  CommentCellView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 12/10/2025.
//

import SwiftUI
import FirebaseFirestore

struct CommentCellView: View {
    let comment: Comment
    @State private var author: User?
    @State private var isLoading = true
    @State private var isLiking = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Author Profile Image
            if let author = author {
                AsyncImage(url: URL(string: author.profileImageUrl ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                        )
                }
                .frame(width: 32, height: 32)
                .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 32, height: 32)
                    .overlay(
                        ProgressView()
                            .scaleEffect(0.5)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                // Author and timestamp
                HStack {
                    if let author = author {
                        Text(author.fullName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("@\(author.username)")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("·")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text(comment.timestampString)
                            .font(.caption)
                            .foregroundColor(.gray)
                    } else {
                        HStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 80, height: 12)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 60, height: 12)
                        }
                    }
                    
                    Spacer()
                }
                
                // Comment content
                Text(comment.content)
                    .font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Action buttons
                HStack(spacing: 20) {
                    // Like button
                    Button {
                        Task {
                            await likeComment()
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: isCommentLiked ? "heart.fill" : "heart")
                                .font(.caption)
                                .foregroundColor(isCommentLiked ? .red : .gray)
                            
                            if comment.likes > 0 {
                                Text("\(comment.likes)")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .disabled(isLiking)
                    
                    Spacer()
                }
                .padding(.top, 4)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .task {
            await loadAuthor()
        }
    }
    
    private var isCommentLiked: Bool {
        guard let currentUserId = UserService.shared.currentUser?.id else { return false }
        return comment.likedBy.contains(currentUserId)
    }
    
    private func loadAuthor() async {
        isLoading = true
        do {
            let fetchedAuthor = try await UserService.shared.fetchUser(withUid: comment.authorId)
            author = fetchedAuthor
        } catch {
            print("Failed to fetch comment author: \(error)")
        }
        isLoading = false
    }
    
    private func likeComment() async {
        guard let commentId = comment.id else { return }
        isLiking = true
        
        do {
            try await CommentService.shared.likeComment(commentId: commentId)
        } catch {
            print("Failed to like comment: \(error)")
        }
        
        isLiking = false
    }
}

#Preview {
    CommentCellView(comment: Comment(
        postId: "sample-post-id",
        authorId: "sample-author-id",
        content: "This is a sample comment that shows how the comment cell looks in the interface.",
        timestamp: Timestamp()
    ))
}

