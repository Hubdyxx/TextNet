//
//  SearchView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 08/12/2024.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack{
            ScrollView{
                LazyVStack{
                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                    } else if viewModel.filteredUsers.isEmpty && !viewModel.searchText.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "person.fill.questionmark")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("No users found")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Text("Try searching with a different name or username")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 100)
                    } else if viewModel.filteredUsers.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "person.2")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("No users yet")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 100)
                    } else {
                        ForEach(viewModel.filteredUsers) { user in
                            NavigationLink(value: user) {
                                VStack {
                                    UserCellView(user: user)
                                    Divider()
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .refreshable {
                await viewModel.refreshUsers()
            }
            .navigationDestination(for: User.self, destination: { user in
                ProfileView(user: user)
            })
            .navigationTitle("Search")
            .searchable(text: $viewModel.searchText, prompt: "Search users...")
            .onChange(of: viewModel.searchText) { oldValue, newValue in
                viewModel.updateSearchText(newValue)
            }
        }
    }
}

#Preview {
    SearchView()
}
