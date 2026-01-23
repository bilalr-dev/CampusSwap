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
    
    init(listing: Listing) {
        _viewModel = StateObject(wrappedValue: ItemDetailViewModel(listing: listing))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Image Header
                headerImage
                
                VStack(alignment: .leading, spacing: 16) {
                    // Title and Price
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(viewModel.listing.category.rawValue.uppercased())
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(4)
                            
                            Spacer()
                            
                            if viewModel.listing.isFeatured {
                                Label("Featured", systemImage: "star.fill")
                                    .font(.caption)
                                    .foregroundColor(.yellow)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.black.opacity(0.8))
                                    .cornerRadius(4)
                            }
                        }
                        
                        Text(viewModel.listing.title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(String(format: "€%.2f", viewModel.listing.price))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                    Divider()
                    
                    // Seller Info
                    HStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 40, height: 40)
                            .overlay(Text(viewModel.listing.sellerName.prefix(1)).fontWeight(.bold))
                        
                        VStack(alignment: .leading) {
                            Text("Posted by")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(viewModel.listing.sellerName)
                                .font(.headline)
                        }
                        
                        Spacer()
                        
                        Text(viewModel.listing.createdAt, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        Text(viewModel.listing.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer(minLength: 40)
                    
                    // Actions
                    if viewModel.isCurrentUserSeller {
                        ownerActions
                    } else {
                        buyerActions
                    }
                }
                .padding()
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
            // Feature Button (Placeholder for now)
            if !viewModel.listing.isFeatured {
                Button(action: { /* Navigate to Feature Mock */ }) {
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
