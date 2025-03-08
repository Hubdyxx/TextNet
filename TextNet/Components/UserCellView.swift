//
//  UserCell.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 09/12/2024.
//

import SwiftUI

struct UserCellView: View {
    
    let user: User
    let testPreview = TestPreview()

    var body: some View {
        HStack {
            ProfilePictureView()
            
            VStack(alignment: .leading, spacing: 2){
                Text(user.username)
                    .fontWeight(.semibold)
                
                Text(user.fullName)
                
            }
            .font(.footnote)
            
            Spacer()
            
            Text("Follow")
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(width: 100, height: 30)
                .overlay{
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray3), lineWidth: 1)
                }
        }
        .padding(.horizontal)
    }
}
#Preview {
    UserCellView(user: TestPreview.shared.user)
}


