//
//  ProfileViewModel.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 08/02/2025.
//

import Foundation
import Combine
import PhotosUI
import SwiftUI

class CurrentUserProfileViewModel: ObservableObject {
    @Published var currentUser: User?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
            
        }.store(in: &cancellables)
    }
}
