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
    
    var body: some View {
        NavigationStack {
            List {
                // Header Section
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 70, height: 70)
                            .overlay(Text(viewModel.currentUser?.name.prefix(1) ?? "?")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.blue))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.currentUser?.name ?? "Guest")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(viewModel.currentUser?.contact ?? "No contact info")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // My Listings Section
                Section(header: Text("My Listings")) {
                    if viewModel.userListings.isEmpty {
                        Text("You haven't posted any items yet.")
                            .foregroundColor(.secondary)
                            .italic()
                            .padding(.vertical)
                    } else {
                        ForEach(viewModel.userListings) { listing in
                            NavigationLink(destination: ItemDetailView(listing: listing)) {
                                ListingRow(listing: listing) // Reuse from Feed
                            }
                        }
                        .onDelete(perform: viewModel.deleteListing)
                    }
                }
                
                // Account Actions
                Section {
                    Button("Sign Out", role: .destructive) {
                        viewModel.signOut()
                    }
                }
            }
            .navigationTitle("My Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingCreateListing = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingCreateListing) {
                CreateListingView()
            }
        }
    }
}

#Preview {
    ProfileView()
}
