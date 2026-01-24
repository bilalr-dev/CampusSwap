//
//  FeaturedListingView.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import SwiftUI

struct FeaturedListingView: View {
    let listing: Listing
    @Environment(\.dismiss) private var dismiss
    @State private var isProcessing = false
    @State private var showingSuccess = false
    
    // Dependencies
    private let featuredService = FeaturedService.shared
    private let listingService = ListingService.shared
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "star.circle.fill")
                        .font(.system(size: 80))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, .yellow)
                        .shadow(radius: 10)
                    
                    Text("Boost Your Visibility")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Feature your listing to sell it 3x faster!")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
                .padding(.top, 40)
                
                // Benefits
                VStack(alignment: .leading, spacing: 16) {
                    BenefitRow(icon: "eye.fill", text: "Appears at the top of the feed")
                    BenefitRow(icon: "sparkles", text: "Highlighted with a special badge")
                    BenefitRow(icon: "clock.fill", text: "Active for 7 days")
                }
                .padding(24)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(16)
                .padding(.horizontal)
                
                Spacer()
                
                // Item Preview
                HStack {
                    Text("Boosting:")
                        .foregroundColor(.secondary)
                    Text(listing.title)
                        .fontWeight(.semibold)
                }
                .font(.footnote)
                
                // Action Button
                Button(action: purchaseFeature) {
                    if isProcessing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Pay €2.99")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom, 20)
                .disabled(isProcessing)
            }
            .navigationTitle("Feature Listing")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Success!", isPresented: $showingSuccess) {
                Button("Done") {
                    dismiss()
                }
            } message: {
                Text("Your listing is now featured and will appear at the top of the feed.")
            }
        }
    }
    
    private func purchaseFeature() {
        isProcessing = true
        
        // Simulate network request / payment processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Success
            featuredService.setFeatured(id: listing.id, isFeatured: true)
            // Force listing service update to UI reflects change immediately
            try? listingService.updateListing(listing)
            
            isProcessing = false
            showingSuccess = true
        }
    }
}

struct BenefitRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.title3)
                .frame(width: 30)
            
            Text(text)
                .font(.body)
        }
    }
}

#Preview {
    FeaturedListingView(listing: Listing(id: UUID(), title: "Sample Item", description: "", price: 10, category: .textbook, sellerId: UUID(), sellerName: "", sellerContact: "", createdAt: Date()))
}
