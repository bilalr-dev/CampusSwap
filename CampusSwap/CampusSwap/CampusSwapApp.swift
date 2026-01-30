//
//  CampusSwapApp.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import SwiftUI

@main
struct CampusSwapApp: App {
    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
    }
}

struct AppRootView: View {
    @ObservedObject private var userService = UserService.shared
    
    var body: some View {
        Group {
            if userService.currentUser != nil {
                ContentView()
            } else {
                WelcomeView()
            }
        }
    }
}
