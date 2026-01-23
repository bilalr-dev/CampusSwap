//
//  ProfileView.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Hello World")
                    .font(.largeTitle)
                    .padding()
            }
            .navigationTitle("My Listings")
        }
    }
}

#Preview {
    ProfileView()
}
