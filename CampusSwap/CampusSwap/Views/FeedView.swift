//
//  FeedView.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    
    // Grid layout definition
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search and Filter Bar
                VStack(spacing: 12) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search listings...", text: $viewModel.searchText)
                        if !viewModel.searchText.isEmpty {
                            Button(action: { viewModel.searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Categories Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            Button(action: { viewModel.selectedCategory = nil }) {
                                Text("All")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(viewModel.selectedCategory == nil ? Color.blue : Color(.systemGray6))
                                    .foregroundColor(viewModel.selectedCategory == nil ? .white : .primary)
                                    .cornerRadius(20)
                            }
                            
                            ForEach(ItemCategory.allCases, id: \.self) { category in
                                Button(action: { viewModel.selectCategory(category) }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: category.icon)
                                        Text(category.rawValue)
                                    }
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(viewModel.selectedCategory == category ? Color.blue : Color(.systemGray6))
                                    .foregroundColor(viewModel.selectedCategory == category ? .white : .primary)
                                    .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 8)
                .background(Color(.systemBackground))
                
                // Main Content
                ScrollView {
                    VStack(spacing: 20) {
                        // Featured Section
                        if !viewModel.featuredListings.isEmpty {
                            FeaturedListingView()
                                .padding(.top, 8)
                        }
                        
                        // Recent Listings Section
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Recent Listings")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                Text("\(viewModel.filteredListings.count) items")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal)
                            
                            if viewModel.allListings.isEmpty {
                                ContentUnavailableView("No Listings Yet", systemImage: "tray", description: Text("Be the first to list an item!"))
                                    .padding(.top, 40)
                            } else if viewModel.filteredListings.isEmpty {
                                ContentUnavailableView.search(text: viewModel.searchText)
                            } else {
                                if viewModel.isGridView {
                                    LazyVGrid(columns: columns, spacing: 16) {
                                        ForEach(viewModel.filteredListings) { listing in
                                            NavigationLink(destination: ItemDetailView()) {
                                                ListingGridItemView(listing: listing)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    .padding(.horizontal)
                                } else {
                                    LazyVStack(spacing: 12) {
                                        ForEach(viewModel.filteredListings) { listing in
                                            NavigationLink(destination: ItemDetailView()) {
                                                ListingCardView(listing: listing)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("CampusSwap")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.toggleViewMode() }) {
                        Image(systemName: viewModel.isGridView ? "list.bullet" : "square.grid.2x2")
                    }
                }
            }
        }
    }
}

#Preview {
    FeedView()
}
