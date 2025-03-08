//
//  SearchView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 08/12/2024.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @StateObject var viewModel = SearchViewModel()
    var body: some View {
        NavigationStack{
            ScrollView{
                LazyVStack{
                    ForEach(viewModel.users) { user in
                        NavigationLink(value: user) {
                            VStack {
                                UserCellView(user: user)
                                
                                Divider()
                            }
                        }                       .padding(.vertical, 4)
                    }
                    
                }
            }
            .navigationDestination(for: User.self, destination: { user in
                ProfileView(user: user)})
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Search")
        }
    }
}

#Preview {
    SearchView()
}
