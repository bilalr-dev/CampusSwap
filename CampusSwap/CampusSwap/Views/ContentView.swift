//
//  ContentView.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Label("Browse", systemImage: "list.bullet")
                }
            
            ProfileView()
                .tabItem {
                    Label("My Listings", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
