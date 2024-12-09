//
//  HomePostView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 08/12/2024.
//

import SwiftUI

struct HomePostView: View {
    var body: some View {
        VStack{
            HStack(alignment: .top, spacing: 10){
                Image(systemName: "person")
                    .scaledToFill()
                    .frame(width: 40,height: 40)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4){
                    HStack {
                        Text("user1")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text("30 sec")
                            .font(.caption)
                            .foregroundColor(Color.gray)
                        
                        Button{
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(Color(.darkGray))
                        }
                    }
                    Text("Here I am")
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                    
                    HStack(spacing: 16){
                        Button {
                            
                        } label: {
                            Image(systemName: "heart")
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "bubble.right")
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "arrow.rectanglepath")
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "paperplane")
                        }
                        
                        
                    }
                    .foregroundColor(.black)
                    .padding(.vertical, 6)
                }
            }
            Divider()
        }
        .padding(.top)
    }
}

#Preview {
    HomePostView()
}
