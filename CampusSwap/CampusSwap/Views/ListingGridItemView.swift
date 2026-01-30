//
//  ListingGridItemView.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import SwiftUI

struct ListingGridItemView: View {
    let listing: Listing
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image
            ZStack(alignment: .topTrailing) {
                Color.gray.opacity(0.1)
                    .aspectRatio(1, contentMode: .fit)
                
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundColor(.gray.opacity(0.5))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                if listing.isFeatured {
                    Image(systemName: "star.circle.fill")
                        .foregroundColor(.yellow)
                        .background(Color.white.clipShape(Circle()))
                        .padding(6)
                }
            }
            .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(listing.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .frame(height: 40, alignment: .topLeading)
                
                Text(String(format: "€%.2f", listing.price))
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack {
                    Image(systemName: listing.category.icon)
                        .font(.caption2)
                    Text(listing.category.rawValue)
                        .font(.caption2)
                }
                .foregroundColor(.secondary)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
    }
}

#Preview {
    ListingGridItemView(listing: Listing(
        title: "Ikea Desk Lamp",
        description: "Like new",
        price: 15.0,
        category: .furniture,
        sellerId: UUID(),
        sellerName: "Jane Doe",
        sellerContact: "jane@example.com",
        isFeatured: true
    ))
    .frame(width: 160)
}
