//
//  ProfilePostFilter.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 12/12/2024.
//

import Foundation

enum ProfilePostFilter: Int, CaseIterable, Identifiable {
    case posts 
    case replies
    
    var title: String {
        switch self {
        case .posts:
            return "Posts"
        case .replies:
            return "Replies"
        }
    }
    var id: Int { return self.rawValue }
}
