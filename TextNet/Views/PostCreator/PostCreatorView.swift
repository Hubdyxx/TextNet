//
//  PostCreatorView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 08/12/2024.
//

import SwiftUI

struct PostCreatorView: View {
    @State private var post = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack{
            VStack{
                HStack(alignment:.top) {
                    ProfilePictureView()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("user")
                            .fontWeight(.semibold)
                        TextField("Tell us something...", text: $post, axis: .vertical)
                    }
                    .font(.footnote)
                    
                    Spacer()
                    
                    if !post.isEmpty {
                        Button{
                            post=""
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.gray)
                        }
                    }
                }
                 Spacer()
            }
            .padding()
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel"){
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundColor(.black)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post"){
                        
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                }
                
            }
        }
    }
}

#Preview {
    PostCreatorView()
}
