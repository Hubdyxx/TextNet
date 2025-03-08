//
//  ProfileHeaderView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 08/03/2025.
//

import SwiftUI

struct ProfileHeaderView: View {
    var user: User?
    
    init(user: User? = nil) {
        self.user = user
    }
    var body: some View {
        HStack(alignment: .top) {
            //bio
            VStack(alignment: .leading, spacing: 10) {
                //username
                VStack(alignment: .leading, spacing: 4) {
                    Text(user?.fullName ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(user?.username ?? "")
                        .font(.subheadline)
                    
                }
                if let bio = user?.bio {
                    Text(bio)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Text("34 Followers")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            ProfilePictureView()
        }
    }
}

#Preview {
    ProfileHeaderView(user: TestPreview.shared.user)
}
