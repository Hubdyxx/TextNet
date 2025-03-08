//
//  User.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 08/02/2025.
//

import Foundation

struct User: Identifiable, Codable, Hashable{
    let id: String
    let fullName: String
    let email: String
    let username: String
    var profileImageUrl: String? = nil
    var bio: String? = nil
}
 
