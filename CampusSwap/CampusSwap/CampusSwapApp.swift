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
    @State private var hasUserProfile = false
    
    var body: some View {
        Group {
            if hasUserProfile {
                ContentView()
            } else {
                ProfileSetupView {
                    hasUserProfile = true
                }
            }
        }
        .onAppear {
            // Check if user profile exists
            hasUserProfile = UserService.shared.getCurrentUser() != nil
        }
    }
}
