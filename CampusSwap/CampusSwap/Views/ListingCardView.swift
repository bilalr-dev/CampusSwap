//
//  ListingCardView.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import SwiftUI

struct ListingCardView: View {
    let listing: Listing
    
    var body: some View {
        HStack(spacing: 12) {
            // Image Placeholder
            ZStack {
                Color.gray.opacity(0.1)
                if let imageName = listing.imageName, !imageName.isEmpty {
                    Image(systemName: "photo") // Placeholder until real images
                        .foregroundColor(.gray)
                } else {
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 80, height: 80)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(listing.title)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if listing.isFeatured {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                }
                
                Text(listing.category.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(4)
                
                Spacer()
                
                HStack {
                    Text(String(format: "€%.2f", listing.price))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(listing.createdAt, style: .date)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    ListingCardView(listing: Listing(
        title: "Calculus Textbook",
        description: "Good condition",
        price: 35.0,
        category: .textbook,
        sellerId: UUID(),
        sellerName: "John Doe",
        sellerContact: "john@example.com",
        isFeatured: true
    ))
    .padding()
}
