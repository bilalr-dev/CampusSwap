//
//  ItemDetailView.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import SwiftUI

struct ItemDetailView: View {
    let listingId: UUID
    
    @StateObject private var viewModel: ItemDetailViewModel
    @State private var showingFeatureModal = false
    
    init(listingId: UUID) {
        self.listingId = listingId
        _viewModel = StateObject(wrappedValue: ItemDetailViewModel())
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let listing = viewModel.listing {
                    // Image Section
                    ZStack {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(Color(.systemGray5))
                            .frame(height: 300)
                        
                        Image(systemName: listing.category.icon)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue)
                    }
                    .overlay(alignment: .topTrailing) {
                        if listing.isFeatured {
                            HStack {
                                Image(systemName: "star.fill")
                                Text("Featured")
                            }
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.yellow)
                            .cornerRadius(8)
                            .padding()
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Title and Category
                        VStack(alignment: .leading, spacing: 8) {
                            Text(listing.title)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            HStack {
                                Image(systemName: listing.category.icon)
                                Text(listing.category.rawValue)
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        }
                        
                        Divider()
                        
                        // Price
                        Text("€\(String(format: "%.2f", listing.price))")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        
                        Divider()
                        
                        // Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                            
                            Text(listing.description)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        
                        Divider()
                        
                        // Seller Info
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Seller")
                                .font(.headline)
                            
                            Text(listing.sellerName)
                                .font(.body)
                        }
                        
                        Divider()
                        
                        // Date
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Posted")
                                .font(.headline)
                            
                            Text(listing.createdAt, style: .date)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        if viewModel.isCurrentUserListing {
                            // Owner view - can feature/unfeature
                            Button(action: {
                                if listing.isFeatured {
                                    viewModel.unfeatureListing()
                                } else {
                                    showingFeatureModal = true
                                }
                            }) {
                                HStack {
                                    Image(systemName: listing.isFeatured ? "star.fill" : "star")
                                    Text(listing.isFeatured ? "Featured Listing" : "Feature This Listing")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(listing.isFeatured ? Color.gray : Color.blue)
                                .cornerRadius(12)
                            }
                        } else {
                            // Buyer view - can contact seller
                            Button(action: viewModel.showContactInfo) {
                                HStack {
                                    Image(systemName: "message.fill")
                                    Text("Contact Seller")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding()
                } else if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray)
                        
                        Text("Listing not found")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadListing(id: listingId)
        }
        .alert("Contact Information", isPresented: $viewModel.showingContactInfo) {
            Button("OK", role: .cancel) { }
        } message: {
            if let contact = viewModel.contactInfo {
                Text("Contact \(viewModel.sellerName) at:\n\(contact)")
            } else {
                Text("Contact information not available")
            }
        }
        .sheet(isPresented: $showingFeatureModal) {
            if let listing = viewModel.listing {
                FeatureListingView(listing: listing) {
                    viewModel.featureListing()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ItemDetailView(listingId: UUID())
    }
}
