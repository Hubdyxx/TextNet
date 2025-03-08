//
//  ProfileView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 08/12/2024.
//

import SwiftUI

struct ProfileView: View {
    
    let user: User
    
    var body: some View {
        
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    ProfileHeaderView(user: user)
                    
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
                    UserContentListView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
        
    }
}

#Preview {
    ProfileView(user: TestPreview.shared.user)
}
