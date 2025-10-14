//
//  CommentInputView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 12/10/2025.
//

import SwiftUI
import FirebaseFirestore

struct CommentInputView: View {
    let postId: String
    let onCommentAdded: (Comment) -> Void
    
    @State private var commentText = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 12) {
                // User avatar
                if let currentUser = UserService.shared.currentUser {
                    AsyncImage(url: URL(string: currentUser.profileImageUrl ?? "")) { image in
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
                }
                
                // Text input
                HStack(spacing: 8) {
                    TextField("Write a comment...", text: $commentText, axis: .vertical)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(.body)
                        .focused($isTextFieldFocused)
                        .lineLimit(1...4)
                        .disabled(isLoading)
                    
                    Button {
                        Task {
                            await createComment()
                        }
                    } label: {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(isCommentValid ? .blue : .gray)
                                .font(.system(size: 16))
                        }
                    }
                    .disabled(!isCommentValid || isLoading)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(20)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
        }
        .alert("Error", isPresented: .constant(errorMessage != nil)) {
            Button("OK") {
                errorMessage = nil
            }
        } message: {
            if let errorMessage = errorMessage {
                Text(errorMessage)
            }
        }
    }
    
    private var isCommentValid: Bool {
        !commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func createComment() async {
        guard isCommentValid else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let trimmedContent = commentText.trimmingCharacters(in: .whitespacesAndNewlines)
            try await CommentService.shared.createComment(postId: postId, content: trimmedContent)
            
            // Create a temporary comment for immediate UI update
            let tempComment = Comment(
                postId: postId,
                authorId: UserService.shared.currentUser?.id ?? "",
                content: trimmedContent,
                timestamp: Timestamp()
            )
            
            onCommentAdded(tempComment)
            commentText = ""
            isTextFieldFocused = false
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

#Preview {
    CommentInputView(postId: "sample-post-id") { comment in
        print("Comment added: \(comment.content)")
    }
    .background(Color(.systemGroupedBackground))
}

