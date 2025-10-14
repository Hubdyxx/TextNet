//
//  NotificationsViewModel.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 12/10/2025.
//

import Foundation
import FirebaseAuth

@MainActor
class NotificationsViewModel: ObservableObject {
    @Published var notifications: [NotificationModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var unreadCount = 0
    
    func fetchNotifications() async {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedNotifications = try await NotificationService.shared.fetchNotifications(for: currentUserId)
            notifications = fetchedNotifications
            await fetchUnreadCount()
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    func fetchUnreadCount() async {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        do {
            let count = try await NotificationService.shared.fetchUnreadNotificationsCount(for: currentUserId)
            unreadCount = count
        } catch {
            print("Failed to fetch unread count: \(error)")
        }
    }
    
    func markAsRead(_ notification: NotificationModel) async {
        guard let notificationId = notification.id else { return }
        
        do {
            try await NotificationService.shared.markAsRead(notificationId: notificationId)
            
            // Update local state
            if let index = notifications.firstIndex(where: { $0.id == notificationId }) {
                notifications[index].isRead = true
            }
            
            await fetchUnreadCount()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func markAllAsRead() async {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        do {
            try await NotificationService.shared.markAllAsRead(for: currentUserId)
            
            // Update local state
            for index in notifications.indices {
                notifications[index].isRead = true
            }
            
            unreadCount = 0
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteNotification(_ notification: NotificationModel) async {
        guard let notificationId = notification.id else { return }
        
        do {
            try await NotificationService.shared.deleteNotification(notificationId: notificationId)
            
            // Remove from local state
            notifications.removeAll { $0.id == notificationId }
            
            await fetchUnreadCount()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func clearError() {
        errorMessage = nil
    }
}

