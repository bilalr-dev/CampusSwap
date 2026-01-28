//
//  FeaturedListingView.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import SwiftUI

struct FeaturedListingView: View {
    let listing: Listing
    
    var body: some View {
        HStack(spacing: 0) {
            // Image Section
            ZStack {
                Color.gray.opacity(0.2)
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                    .foregroundColor(.yellow.opacity(0.8))
            }
            .frame(width: 120)
            
            // Details Section
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("FEATURED")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(4)
                    
                    Spacer()
                    
                    Text(listing.category.rawValue)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Text(listing.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Spacer()
                
                Text(String(format: "€%.2f", listing.price))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            .padding(12)
        }
        .frame(width: 300, height: 140)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    FeaturedListingView(listing: Listing(
        title: "MacBook Pro M1",
        description: "Great condition",
        price: 850.0,
        category: .furniture, // Using existing enum
        sellerId: UUID(),
        sellerName: "Tech Guy",
        sellerContact: "tech@example.com",
        isFeatured: true
    ))
}
