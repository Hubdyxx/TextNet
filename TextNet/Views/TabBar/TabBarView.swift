//
//  TabBarView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 01/12/2024.
//

import SwiftUI
import Foundation

struct TabBarView: View {
    @State private var selectedTab = 0
    @State private var showCreatePostView = false
    @StateObject private var notificationsViewModel = NotificationsViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                }
                .onAppear { selectedTab = 0 }
                .tag(0)
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .onAppear { selectedTab = 1 }
                .tag(1)
            PostCreatorView()
                .tabItem {
                    Image(systemName: "plus")
                }
                .onAppear { selectedTab = 2 }
                .tag(2)
            NotificationsView()
                .tabItem {
                    ZStack {
                        Image(systemName: selectedTab == 3 ? "heart.fill" : "heart")
                            .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
                        
                        if notificationsViewModel.unreadCount > 0 {
                            Text("\(notificationsViewModel.unreadCount)")
                                .font(.caption2)
                                .foregroundColor(.white)
                                .frame(width: 16, height: 16)
                                .background(Color.red)
                                .clipShape(Circle())
                                .offset(x: 8, y: -8)
                        }
                    }
                }
                .onAppear { selectedTab = 3 }
                .tag(3)
            CurrentUserProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "person.fill" : "person")
                        .environment(\.symbolVariants, selectedTab == 4 ? .fill : .none)
                }
                .onAppear { selectedTab = 4 }
                .tag(4)
                
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            showCreatePostView = newValue == 2
        }
        .sheet(isPresented: $showCreatePostView, onDismiss: {
            selectedTab = 0
        }, content: {
            PostCreatorView()
        })
        .tint(.black)
        .task {
            await notificationsViewModel.fetchUnreadCount()
        }
        .onReceive(Timer.publish(every: 30, on: .main, in: .common).autoconnect()) { _ in
            Task {
                await notificationsViewModel.fetchUnreadCount()
            }
        }
    }
}

#Preview {
    TabBarView()
}
