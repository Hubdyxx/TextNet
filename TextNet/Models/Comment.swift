//
//  Comment.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 12/10/2025.
//

import Foundation
import FirebaseFirestore

struct Comment: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    let postId: String
    let authorId: String
    let content: String
    let timestamp: Timestamp
    var likes: Int = 0
    var likedBy: [String] = []
    
    var timestampString: String {
        return timestamp.dateValue().timeAgoDisplay()
    }
}

