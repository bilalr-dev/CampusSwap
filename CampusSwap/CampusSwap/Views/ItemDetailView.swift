//
//  ItemDetailView.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import SwiftUI

struct ItemDetailView: View {
    @StateObject private var viewModel: ItemDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteAlert = false
    @State private var showingFeatureSheet = false
    
    init(listing: Listing) {
        _viewModel = StateObject(wrappedValue: ItemDetailViewModel(listing: listing))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero Image
                ZStack(alignment: .bottomLeading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .aspectRatio(1.2, contentMode: .fill)
                        .overlay(
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .padding(60)
                                .foregroundColor(.gray.opacity(0.3))
                        )
                    
                    // Gradient Overlay
                    LinearGradient(colors: [.black.opacity(0.6), .clear], startPoint: .bottom, endPoint: .top)
                        .frame(height: 120)
                    
                    // Title over Image
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(viewModel.listing.category.rawValue.uppercased())
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(4)
                            
                            Spacer()
                            
                            if viewModel.listing.isFeatured {
                                Label("Featured", systemImage: "star.fill")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.yellow)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.black.opacity(0.6))
                                    .cornerRadius(4)
                            }
                        }
                        
                        Text(viewModel.listing.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .shadow(radius: 2)
                    }
                    .foregroundColor(.white)
                    .padding()
                }
                
                VStack(alignment: .leading, spacing: 24) {
                    // Price and Date Row
                    HStack(alignment: .firstTextBaseline) {
                        Text(String(format: "€%.2f", viewModel.listing.price))
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.blue)
                        
                        Spacer()
                        
                        Text("Posted \(viewModel.listing.createdAt, style: .date)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Seller Card
                    HStack(spacing: 12) {
                        Circle()
                            .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Text(viewModel.listing.sellerName.prefix(1))
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading) {
                            Text("Sold by")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(viewModel.listing.sellerName)
                                .font(.headline)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        Text(viewModel.listing.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                }
                .padding(24)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .safeAreaInset(edge: .bottom) {
            // Floating Action Bar
            VStack {
                Divider()
                HStack {
                    if viewModel.isCurrentUserSeller {
                        ownerActions
                    } else {
                        buyerActions
                    }
                }
                .padding()
                .background(Color(.systemBackground))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert("Contact Seller", isPresented: $viewModel.showingContactInfo) {
            Button("Copy Email") {
                UIPasteboard.general.string = viewModel.listing.sellerContact
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Contact: \(viewModel.listing.sellerContact)")
        }
        .alert("Delete Listing?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteListing()
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this listing? This action cannot be undone.")
        }
        .sheet(isPresented: $showingFeatureSheet, onDismiss: { viewModel.refreshListing() }) {
            FeaturedListingView(listing: viewModel.listing)
        }
    }
    
    private var headerImage: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.1))
            .aspectRatio(1.5, contentMode: .fit)
            .overlay(
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    .foregroundColor(.gray.opacity(0.5))
            )
    }
    
    private var buyerActions: some View {
        Button(action: {
            viewModel.showingContactInfo = true
        }) {
            Text("Contact Seller")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
    }
    
    private var ownerActions: some View {
        VStack(spacing: 12) {
            // Feature Button
            if !viewModel.listing.isFeatured {
                Button(action: { showingFeatureSheet = true }) {
                    Label("Feature This Listing", systemImage: "star.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                }
            }
            
            Button(action: { showingDeleteAlert = true }) {
                Text("Delete Listing")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .foregroundColor(.red)
                    .cornerRadius(12)
            }
        }
    }
}
