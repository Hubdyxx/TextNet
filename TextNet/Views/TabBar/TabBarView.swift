//
//  TabBarView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 01/12/2024.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Main View")
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                }
                .onAppear { selectedTab = 0 }
                .tag(0)
            Text("Explore")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .onAppear { selectedTab = 1 }
                .tag(1)
            Text("Add post")
                .tabItem {
                    Image(systemName: "plus")
                }
                .onAppear { selectedTab = 2 }
                .tag(2)
            Text("Activity")
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "heart.fill" : "heart")
                        .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
                }
                .onAppear { selectedTab = 3 }
                .tag(3)
            Text("Profile")
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "person.fill" : "person")
                        .environment(\.symbolVariants, selectedTab == 4 ? .fill : .none)
                }
                .onAppear { selectedTab = 4 }
                .tag(4)
                
        }
        .tint(.black)
    }
}

#Preview {
    TabBarView()
}