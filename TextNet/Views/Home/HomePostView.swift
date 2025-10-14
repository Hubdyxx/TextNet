//
//  HomePostView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 08/12/2024.
//

import SwiftUI
import Foundation

struct HomePostView: View {
    let post: Post
    @State private var isLiked = false
    @State private var likesCount: Int
    @State private var postOwner: User?
    @State private var timeAgoText: String = ""
    @State private var refreshTrigger: UUID = UUID()
    
    init(post: Post) {
        self.post = post
        self._likesCount = State(initialValue: post.likes)
        self._isLiked = State(initialValue: false)
        self._timeAgoText = State(initialValue: post.timestamp.dateValue().timeAgoDisplay())
    }
    
    var body: some View {
        VStack{
            HStack(alignment: .top, spacing: 10){
                AsyncImage(url: URL(string: postOwner?.profileImageUrl ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Image(systemName: "person")
                        .foregroundColor(.gray)
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4){
                    HStack {
                        Text(postOwner?.username ?? "Unknown User")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text(timeAgoText)
                            .font(.caption)
                            .foregroundColor(Color.gray)
                        
                        if let currentUserId = UserService.shared.currentUser?.id,
                           currentUserId == post.ownerId {
                            Button{
                                deletePost()
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(Color(.darkGray))
                            }
                        }
                    }
                    Text(post.content)
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                    
                    HStack(spacing: 16){
                        Button {
                            toggleLike()
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: isLiked ? "heart.fill" : "heart")
                                    .foregroundColor(isLiked ? .red : .black)
                                Text("\(likesCount)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        NavigationLink(destination: PostDetailView(post: post)) {
                            Image(systemName: "bubble.right")
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "arrow.rectanglepath")
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "paperplane")
                        }
                        
                        
                    }
                    .foregroundColor(.black)
                    .padding(.vertical, 6)
                }
            }
            Divider()
        }
        .padding(.top)
        .task {
            await fetchPostOwner()
            checkIfLiked()
            updateTimeAgo()
        }
        .onReceive(Timer.publish(every: 30, on: .main, in: .common).autoconnect()) { _ in
            updateTimeAgo()
        }
        .onAppear {
            updateTimeAgo()
        }
        .onChange(of: refreshTrigger) { _, _ in
            updateTimeAgo()
        }
    }
    
    private func fetchPostOwner() async {
        do {
            let users = try await UserService.fetchUsers()
            if let owner = users.first(where: { $0.id == post.ownerId }) {
                postOwner = owner
            } else if let currentUser = UserService.shared.currentUser,
                      currentUser.id == post.ownerId {
                postOwner = currentUser
            }
        } catch {
            print("Failed to fetch post owner: \(error)")
        }
    }
    
    private func checkIfLiked() {
        guard let currentUserId = UserService.shared.currentUser?.id else { return }
        isLiked = post.likedBy.contains(currentUserId)
    }
    
    private func toggleLike() {
        guard let postId = post.id else { return }
        
        Task {
            do {
                try await PostService.shared.likePost(postId: postId)
                
                await MainActor.run {
                    if isLiked {
                        likesCount = max(0, likesCount - 1)
                    } else {
                        likesCount += 1
                    }
                    isLiked.toggle()
                }
            } catch {
                print("Failed to toggle like: \(error)")
            }
        }
    }
    
    private func deletePost() {
        guard let postId = post.id else { return }
        
        Task {
            do {
                try await PostService.shared.deletePost(postId: postId)
            } catch {
                print("Failed to delete post: \(error)")
            }
        }
    }
    
    private func updateTimeAgo() {
        timeAgoText = post.timestamp.dateValue().timeAgoDisplay()
    }
}

#Preview {
    HomePostView(post: Post(ownerId: "test", content: "This is a test post", timestamp: .init()))
}
