import SwiftUI

struct FeaturedListingView: View {
    @StateObject private var listingService = ListingService.shared
    @State private var showPremiumPurchase = false
    
    var featuredListings: [Listing] {
        listingService.listings.filter { $0.isFeatured }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Featured")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Label("Premium", systemImage: "crown.fill")
                    .font(.caption)
                    .foregroundColor(.yellow) // Fallback color if .premiumGold not defined
                    .padding(6)
                    .background(Color.black.opacity(0.8)) // Fallback if .premiumDark not defined
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    // List of featured items
                    ForEach(featuredListings) { listing in
                        NavigationLink(destination: ItemDetailView()) {
                            FeaturedCard(listing: listing)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    // "Go Premium" Upsell Card
                    PremiumUpsellCard {
                        showPremiumPurchase = true
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
        }
        .sheet(isPresented: $showPremiumPurchase) {
            PremiumPurchaseView()
        }
        .onAppear {
            listingService.loadListings()
        }
    }
}

// MARK: - Subviews

struct FeaturedCard: View {
    let listing: Listing
    
    var body: some View {
        VStack(alignment: .leading) {
            // Image Placeholder
            ZStack {
                Color.gray.opacity(0.1)
                Image(systemName: listing.imageName ?? "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .foregroundColor(.gray)
            }
            .frame(height: 120)
            .cornerRadius(10)
            
            Text(listing.title)
                .font(.headline)
                .lineLimit(1)
            
            Text(String(format: "$%.2f", listing.price))
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .frame(width: 160, height: 200)
        // .premiumCardStyle() // Commenting out custom modifier if not available, or I should check Extensions.swift
    }
}

struct PremiumUpsellCard: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: "crown.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                    .foregroundColor(.yellow)
                    .padding()
                
                Text("Boost Your Item")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Get 10x more views")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(width: 160, height: 200)
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        Color.yellow,
                        style: StrokeStyle(lineWidth: 2, dash: [5])
                    )
            )
        }
    }
}

struct PremiumPurchaseView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "crown.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.yellow)
                    .shadow(color: .yellow.opacity(0.5), radius: 20)
                
                Text("Go Premium")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Boost your listings to the top of the feed and sell 3x faster.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.8))
                    .padding()
                
                Button(action: {
                    // Logic to purchase would go here
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Purchase for $4.99")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Button("No Thanks") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.gray)
            }
            .padding()
        }
    }
}

#Preview {
    FeaturedListingView()
}
