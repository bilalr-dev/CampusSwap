//
//  ProfileView.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingCreateListing = false
    @State private var selectedListing: Listing?
    @State private var showingEditListing = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // User Info Section
                VStack(spacing: 12) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                    
                    if let user = viewModel.currentUser {
                        Text(user.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(user.contact)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                
                // My Listings Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("My Listings")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: { showingCreateListing = true }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("New Listing")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else if viewModel.userListings.isEmpty {
                        // Empty State
                        VStack(spacing: 16) {
                            Image(systemName: "tray")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.gray)
                            
                            Text("No Listings Yet")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text("Create your first listing to start selling!")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            
                            Button(action: { showingCreateListing = true }) {
                                Text("Create Listing")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 60)
                    } else {
                        // Listings List
                        List {
                            ForEach(viewModel.userListings) { listing in
                                NavigationLink(destination: EditListingView(listing: listing)) {
                                    ListingRowView(listing: listing)
                                }
                            }
                            .onDelete(perform: viewModel.deleteListings)
                        }
                        .listStyle(.plain)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingCreateListing) {
                CreateListingView()
            }
            .onAppear {
                viewModel.loadUserListings()
            }
        }
    }
}

// Helper view for listing row in profile
struct ListingRowView: View {
    let listing: Listing
    
    var body: some View {
        HStack(spacing: 12) {
            // Category Icon
            Image(systemName: listing.category.icon)
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)
                .padding(8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(listing.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(listing.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("€\(String(format: "%.2f", listing.price))")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            if listing.isFeatured {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ProfileView()
}
