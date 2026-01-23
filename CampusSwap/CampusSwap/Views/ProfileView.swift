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
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header Card
                    VStack(spacing: 16) {
                        Circle()
                            .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Text(viewModel.currentUser?.name.prefix(1) ?? "?")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.white)
                            )
                            .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        VStack(spacing: 4) {
                            Text(viewModel.currentUser?.name ?? "Guest")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .font(.caption)
                                Text(viewModel.currentUser?.contact ?? "No contact info")
                                    .font(.subheadline)
                            }
                            .foregroundColor(.secondary)
                        }
                        
                        Button(action: { viewModel.signOut() }) {
                            Text("Sign Out")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.red)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(20)
                        }
                        .padding(.top, 8)
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                    
                    // My Listings Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("My Listings")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            if !viewModel.userListings.isEmpty {
                                Text("\(viewModel.userListings.count) items")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal)
                        
                        if viewModel.userListings.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "square.stack.3d.up.slash")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray.opacity(0.5))
                                Text("You haven't posted any items yet.")
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        } else {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.userListings) { listing in
                                    NavigationLink(destination: ItemDetailView(listing: listing)) {
                                        ListingRow(listing: listing)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            // Find index and delete
                                            if let index = viewModel.userListings.firstIndex(where: { $0.id == listing.id }) {
                                                viewModel.deleteListing(at: IndexSet(integer: index))
                                            }
                                        } label: {
                                            Label("Delete listing", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingCreateListing = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue)
                            .clipShape(Circle())
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
