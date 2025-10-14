//
//  CommentCreatorView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 12/10/2025.
//

import SwiftUI

struct CommentCreatorView: View {
    let postId: String
    let onCommentCreated: () -> Void
    
    @StateObject private var viewModel: CommentCreatorViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingAlert = false
    
    init(postId: String, onCommentCreated: @escaping () -> Void) {
        self.postId = postId
        self.onCommentCreated = onCommentCreated
        self._viewModel = StateObject(wrappedValue: CommentCreatorViewModel(postId: postId))
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Write a comment")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    TextEditor(text: $viewModel.commentContent)
                        .font(.body)
                        .padding(.horizontal)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .overlay(
                            VStack {
                                HStack {
                                    if viewModel.commentContent.isEmpty {
                                        Text("What are your thoughts?")
                                            .foregroundColor(.gray)
                                            .font(.body)
                                            .padding(.leading, 20)
                                            .padding(.top, 8)
                                    }
                                    Spacer()
                                }
                                Spacer()
                            }
                        )
                        .frame(minHeight: 100)
                }
                
                Spacer()
            }
            .navigationTitle("New Comment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        if !viewModel.commentContent.isEmpty {
                            showingAlert = true
                        } else {
                            dismiss()
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Comment") {
                        Task {
                            let success = await viewModel.createComment()
                            if success {
                                onCommentCreated()
                                dismiss()
                            }
                        }
                    }
                    .disabled(!viewModel.isCommentButtonEnabled)
                    .opacity(viewModel.isCommentButtonEnabled ? 1.0 : 0.5)
                }
            }
            .alert("Discard comment?", isPresented: $showingAlert) {
                Button("Discard", role: .destructive) {
                    viewModel.clearComment()
                    dismiss()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Your comment will be lost.")
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                        
                        VStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .scaleEffect(1.2)
                            
                            Text("Posting comment...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.top, 8)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(radius: 4)
                    }
                }
            }
        }
    }
}

#Preview {
    CommentCreatorView(postId: "sample-post-id") {
        print("Comment created")
    }
}

