//
//  PhotoUploader.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 21/03/2025.
//

import Foundation
import Firebase
import FirebaseStorage

struct PhotoUploader {
    static func uploadPhoto(_ image:UIImage) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.30) else { return nil }
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference(withPath: "/profile_photos/\(filename)")
        
        do {
            let _ = try await storageRef.putDataAsync(imageData)
            let url = try await storageRef.downloadURL()
            return url.absoluteString
        } catch {
            print("Debuug failed to upload photo: \(error.localizedDescription)")
            return nil
        }
    }
}
