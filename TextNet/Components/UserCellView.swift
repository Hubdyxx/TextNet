//
//  UserCell.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 09/12/2024.
//

import SwiftUI

struct UserCell: View {
    var body: some View {
        HStack {
            Image(systemName: "person")
                .resizable()
                .frame(width: 40,height: 40)
                .clipShape(Circle())
            
            VStack(alignment: .leading){
                Text("user1")
                    .fontWeight(.semibold)
                
                Text("Anonymous 1")
                
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
    UserCell()
}
