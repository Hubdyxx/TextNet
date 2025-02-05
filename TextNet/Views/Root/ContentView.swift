//
//  ContentView.swift
//  TextNet
//
//  Created by Hubert Kotlarz on 16/11/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    var body: some View {
        Group{
            if viewModel.userSession != nil{
                TabBarView()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
