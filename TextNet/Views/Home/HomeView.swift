//
//  HomeView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 08/12/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var refreshID = UUID()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    if viewModel.isLoading && viewModel.posts.isEmpty {
                        ProgressView()
                            .padding()
                    } else if viewModel.posts.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "text.bubble")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("No posts yet")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Text("Be the first to share something!")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 100)
                    } else {
                        ForEach(viewModel.posts) { post in
                            HomePostView(post: post)
                                .id("\(post.id ?? "")-\(refreshID)")
                        }
                    }
                }
            }
            .refreshable {
                await viewModel.fetchPosts()
                refreshID = UUID()
            }
            .navigationTitle("TextNet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await viewModel.fetchPosts()
                            refreshID = UUID()
                        }
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(.black)
                    }
                }
            }
            .task {
                await viewModel.fetchPosts()
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.clearError()
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}

#Preview {
    HomeView()
}
