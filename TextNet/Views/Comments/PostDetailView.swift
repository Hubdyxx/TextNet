//
//  PostDetailView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 12/10/2025.
//

import SwiftUI

struct PostDetailView: View {
    let post: Post
    @StateObject private var commentViewModel: CommentViewModel
    @State private var showCommentCreator = false
    
    init(post: Post) {
        self.post = post
        self._commentViewModel = StateObject(wrappedValue: CommentViewModel(postId: post.id ?? ""))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    // Original Post
                    HomePostView(post: post)
                        .padding(.horizontal)
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Comments Section
                    if commentViewModel.isLoading && commentViewModel.comments.isEmpty {
                        ProgressView()
                            .padding()
                    } else if commentViewModel.comments.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "bubble.left")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            Text("No comments yet")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Text("Be the first to comment!")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 50)
                    } else {
                        LazyVStack(spacing: 0) {
                            ForEach(commentViewModel.comments) { comment in
                                CommentCellView(comment: comment)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        if comment.authorId == UserService.shared.currentUser?.id {
                                            Button("Delete") {
                                                Task {
                                                    await commentViewModel.deleteComment(comment)
                                                }
                                            }
                                            .tint(.red)
                                        }
                                    }
                                
                                Divider()
                                    .padding(.leading, 64)
                            }
                        }
                    }
                }
            }
            
            // Comment Input at bottom
            CommentInputView(postId: post.id ?? "") { newComment in
                // Add comment to local state immediately for better UX
                commentViewModel.addComment(newComment)
            }
        }
        .navigationTitle("Post")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showCommentCreator = true
                } label: {
                    Image(systemName: "plus.bubble")
                        .foregroundColor(.blue)
                }
            }
        }
        .sheet(isPresented: $showCommentCreator) {
            CommentCreatorView(postId: post.id ?? "") {
                // Refresh comments after creating new one
                Task {
                    await commentViewModel.fetchComments()
                }
            }
        }
        .task {
            await commentViewModel.fetchComments()
        }
        .refreshable {
            await commentViewModel.fetchComments()
        }
        .alert("Error", isPresented: .constant(commentViewModel.errorMessage != nil)) {
            Button("OK") {
                commentViewModel.clearError()
            }
        } message: {
            Text(commentViewModel.errorMessage ?? "")
        }
    }
}

