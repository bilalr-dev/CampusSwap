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
                ProfileSetupView {
                    // Logic is handled by UserService updates, but callback 
                    // is still needed if ProfileSetupView requires it.
                    // Ideally ProfileSetupView should just save and we react to the change.
                }
            }
        }
    }
}
