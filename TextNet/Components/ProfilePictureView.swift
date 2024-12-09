//
//  ProfilePictureView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 09/12/2024.
//

import SwiftUI

struct ProfilePictureView: View {
    var body: some View {
        Image(systemName: "person")
            .resizable()
            .scaledToFill()
            .frame(width: 40, height: 40)
            .clipShape(Circle())
    }
}

#Preview {
    ProfilePictureView()
}
