//
//  PreviewProvider.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 07/03/2025.
//

import SwiftUI

extension PreviewProvider{
    static var testView: TestPreview {
        return TestPreview.shared
    }
}

class TestPreview{
    static let shared = TestPreview()
    
    let user = User(id: NSUUID().uuidString, fullName: "Maciej Kowalski", email: "maciek@gmail.com", username: "maciek123")
}
