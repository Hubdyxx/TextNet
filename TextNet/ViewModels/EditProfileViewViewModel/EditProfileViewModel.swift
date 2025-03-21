//
//  EditProfileViewModel.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 21/03/2025.
//

import PhotosUI
import SwiftUI

class EditProfileViewModel: ObservableObject {
    @Published var selectedItem: PhotosPickerItem?{
        didSet { Task {await loadImage() } }
    }
    @Published var profileImage: Image?
    private var uiImage: UIImage?
    
    func updateUserData() async throws {
        try await updateProfilePhoto()
    }
    
    @MainActor
    private func loadImage() async {
        guard let item = selectedItem else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage 
        self.profileImage = Image(uiImage: uiImage)
    }
    private func updateProfilePhoto() async throws {
        guard let image = self.uiImage else { return }
        guard let imageURL = try? await PhotoUploader.uploadPhoto(image) else { return }
        try await UserService.shared.updateUserProfilePhoto(withImageUrl: imageURL)
    }
}
