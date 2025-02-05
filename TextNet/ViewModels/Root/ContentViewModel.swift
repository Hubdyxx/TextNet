//
//  ContentViewModel.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 05/02/2025.
//

import Foundation
import Combine
import FirebaseAuth

class ContentViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    private var cancellables = Set<AnyCancellable>()
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        AuthService.shared.$userSesssion.sink { [weak self] userSession in
            self?.userSession = userSession
        }.store(in: &cancellables)
    }
}

