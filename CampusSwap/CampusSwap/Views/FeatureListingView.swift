//
//  FeatureListingView.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import SwiftUI

struct FeatureListingView: View {
    let listing: Listing?
    let onConfirm: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.yellow)
                
                Text("Feature Your Listing")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Make your listing stand out! Featured listings appear at the top of the feed and get priority visibility.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Price:")
                            .font(.headline)
                        Spacer()
                        Text("€5.00")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button(action: {
                        onConfirm()
                        dismiss()
                    }) {
                        Text("Purchase Feature")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    
                    Button(action: { dismiss() }) {
                        Text("Cancel")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
            .padding()
            .navigationTitle("Feature Listing")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    FeatureListingView(listing: nil) { }
}
