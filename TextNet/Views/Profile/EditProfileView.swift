//
//  EditProfileView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 15/12/2024.
//

import SwiftUI

struct EditProfileView: View {
    @State private var bio: String = ""
    @State private var link: String = ""
    @State private var isPrivateProfile = false


    var body: some View {
        NavigationStack{
            ZStack{
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea([.bottom, .horizontal])
                
                VStack{
                    
                    HStack{
                        VStack(alignment: .leading){
                            Text("Name")
                                .fontWeight(.semibold)
                            
                            Text("Marcus Dolan")
                        }
                                                
                        Spacer()
                        
                        ProfilePictureView()
                    }
                    Divider()
                    
                    VStack(alignment: .leading){
                        Text("Bio")
                            .fontWeight(.semibold)
                        
                        TextField("Edit bio", text: $bio, axis:.vertical)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading){
                        Text("Link")
                            .fontWeight(.semibold)
                        
                        TextField("Add links", text: $link)
                    }
                    
                    Divider()
                    
                    Toggle("Private profile", isOn: $isPrivateProfile)
                }
                .font(.footnote)
                .padding()
                .background(.white)
                .cornerRadius(10)
                .padding()

            }
            
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back"){
                        
                    }
                    .font(.subheadline)
                    .foregroundColor(.black)
                    
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done"){
                        
                    }
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .fontWeight(.semibold )
                }
            }
        }
    }
}
#Preview {
    EditProfileView()
}
