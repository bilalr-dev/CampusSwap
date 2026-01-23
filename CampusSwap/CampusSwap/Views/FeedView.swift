//
//  FeedView.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import SwiftUI

struct FeedView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Hello World")
                    .font(.largeTitle)
                    .padding()
            }
            .navigationTitle("CampusSwap")
        }
    }
}

#Preview {
    FeedView()
}
