//
//  ProfileView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 08/12/2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    @State private var selectedFilter: ProfilePostFilter = .posts
    @Namespace var animation
    
    private var filterBarWidth: CGFloat {
        let count = CGFloat(ProfilePostFilter.allCases.count)
        return UIScreen.main.bounds.width / count - 16
    }
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    HStack(alignment: .top) {
                        //bio
                        VStack(alignment: .leading, spacing: 10) {
                            //username
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Mathew Collins")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                Text("mathy321")
                                    .font(.subheadline)
                                
                            }
                            Text("Welcome in my profile")
                                .font(.footnote)
                            
                            Text("34 Followers")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        
                        ProfilePictureView()
                    }
                    Button{
                        
                    } label: {
                        Text("Follow")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 350, height: 30)
                            .background(Color.black)
                            .cornerRadius(8)
                    }
                    
                    //content view
                    VStack{
                        HStack{
                            ForEach(ProfilePostFilter.allCases) { filter in
                                VStack{
                                    Text(filter.title)
                                        .font(.subheadline)
                                        .fontWeight(selectedFilter == filter ? .semibold : .regular)
                                    
                                    if selectedFilter == filter{
                                        Rectangle()
                                            .foregroundColor(.black)
                                            .frame(width: 180, height: 1)
                                            .matchedGeometryEffect(id: "item", in: animation)
                                    } else {
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: 180, height: 1)
                                    }
                                }
                                .onTapGesture{
                                    withAnimation(.spring()) {
                                        selectedFilter = filter
                                    }
                                }
                            }
                        }
                        LazyVStack{
                            ForEach(0 ... 10, id: \.self) { post in
                                HomePostView()
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        AuthService.shared.signOut()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.black)
                    
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ProfileView()
}
