//
//  NotificationsView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 08/12/2024.
//

import SwiftUI

struct NotificationsView: View {
    @StateObject private var viewModel = NotificationsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    if viewModel.isLoading && viewModel.notifications.isEmpty {
                        ProgressView()
                            .padding()
                    } else if viewModel.notifications.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "bell")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("No notifications yet")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Text("When someone likes your posts, you'll see it here")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 100)
                    } else {
                        ForEach(viewModel.notifications) { notification in
                            NotificationCellView(notification: notification)
                                .onTapGesture {
                                    if !notification.isRead {
                                        Task {
                                            await viewModel.markAsRead(notification)
                                        }
                                    }
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button("Delete") {
                                        Task {
                                            await viewModel.deleteNotification(notification)
                                        }
                                    }
                                    .tint(.red)
                                    
                                    if !notification.isRead {
                                        Button("Read") {
                                            Task {
                                                await viewModel.markAsRead(notification)
                                            }
                                        }
                                        .tint(.blue)
                                    }
                                }
                            
                            Divider()
                                .padding(.leading, 64)
                        }
                    }
                }
            }
            .refreshable {
                await viewModel.fetchNotifications()
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.unreadCount > 0 {
                        Button("Mark All Read") {
                            Task {
                                await viewModel.markAllAsRead()
                            }
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }
                }
            }
            .task {
                await viewModel.fetchNotifications()
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
    NotificationsView()
}
