//
//  CurrentUserProfileView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 08/03/2025.
//

import SwiftUI

struct CurrentUserProfileView: View {
    @StateObject var viewModel = CurrentUserProfileViewModel()
    @State private var showEditProfile = false
    
    private var currentUser: User? {
        return viewModel.currentUser
    }
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    ProfileHeaderView(user: currentUser)
                    Button{
                        showEditProfile.toggle()
                    } label: {
                        Text("Edit Profile")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(width: 350, height: 30)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay{
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray3), lineWidth: 1)
                            }
                    }
                    
                    //content view
                    UserContentListView()
                }
            }
            
            .sheet(isPresented: $showEditProfile,  content: {
                EditProfileView()
                    .environmentObject(viewModel)
            })
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
    CurrentUserProfileView()
}
