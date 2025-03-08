//
//  TabBarView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 01/12/2024.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 0
    @State private var showCreatePostView = false
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
                    Image(systemName: selectedTab == 3 ? "heart.fill" : "heart")
                        .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
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
        .onChange(of: selectedTab, perform: { newValue in
            showCreatePostView = selectedTab == 2
        })
        .sheet(isPresented: $showCreatePostView, onDismiss: {
            selectedTab = 0
        }, content: {
            PostCreatorView()
        })
        .tint(.black)
    }
}

#Preview {
    TabBarView()
}
