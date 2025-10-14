//
//  Post.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 12/10/2025.
//

import Foundation
import FirebaseFirestore

struct Post: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    let ownerId: String
    let content: String
    let timestamp: Timestamp
    var likes: Int = 0
    var likedBy: [String] = []
    
    var timestampString: String {
        return timestamp.dateValue().timeAgoDisplay()
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let now = Date()
        let timeInterval = now.timeIntervalSince(self)
        
        let seconds = Int(timeInterval)
        let minutes = seconds / 60
        let hours = minutes / 60
        let days = hours / 24
        
        if seconds < 60 {
            return "\(seconds)s"
        } else if minutes < 60 {
            return "\(minutes)m"
        } else if hours < 24 {
            return "\(hours)h"
        } else {
            // For days and beyond, show the actual date
            let formatter = DateFormatter()
            if days < 7 {
                formatter.dateFormat = "MMM d" // "Jan 15"
            } else if days < 365 {
                formatter.dateFormat = "MMM d" // "Jan 15"
            } else {
                formatter.dateFormat = "MMM d, yyyy" // "Jan 15, 2024"
            }
            return formatter.string(from: self)
        }
    }
}
