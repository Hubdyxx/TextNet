//
//  PostCreatorView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 08/12/2024.
//

import SwiftUI

struct PostCreatorView: View {
    @StateObject private var viewModel = PostCreatorViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack(alignment:.top) {
                    ProfilePictureView()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        if let currentUser = UserService.shared.currentUser {
                            Text(currentUser.username)
                                .fontWeight(.semibold)
                        } else {
                            Text("user")
                                .fontWeight(.semibold)
                        }
                        TextField("Tell us something...", text: $viewModel.postContent, axis: .vertical)
                    }
                    .font(.footnote)
                    
                    Spacer()
                    
                    if !viewModel.postContent.isEmpty {
                        Button{
                            viewModel.clearPost()
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 8)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel"){
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .disabled(viewModel.isLoading)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post"){
                        Task {
                            if await viewModel.createPost() {
                                dismiss()
                            }
                        }
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(viewModel.isPostButtonEnabled ? .black : .gray)
                    .disabled(!viewModel.isPostButtonEnabled)
                }
                
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.1))
                }
            }
        }
    }
}

#Preview {
    PostCreatorView()
}
