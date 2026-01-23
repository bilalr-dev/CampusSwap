//
//  FeedView.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    @State private var isGridView = false
    @State private var showingFilters = false
    
    // Grid layout definition
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                // Main Content
                if viewModel.filteredListings.isEmpty {
                    if viewModel.isLoading {
                        ProgressView("Loading listings...")
                    } else {
                        emptyStateView
                    }
                } else {
                    listingsContent
                }
            }
            .navigationTitle("CampusSwap")
            .searchable(text: $viewModel.searchText, prompt: "Search textbooks, furniture...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        // Filter Button (Category)
                        Menu {
                            Button("All Categories", action: { viewModel.selectedCategory = nil })
                            ForEach(ItemCategory.allCases, id: \.self) { category in
                                Button(category.rawValue, action: { viewModel.selectedCategory = category })
                            }
                        } label: {
                            Image(systemName: viewModel.selectedCategory == nil ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                        }
                        
                        // View Toggle
                        Button(action: { isGridView.toggle() }) {
                            Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                        }
                    }
                }
            }
            .refreshable {
                viewModel.refresh()
            }
        }
    }
    
    // MARK: - Subviews
    
    private var listingsContent: some View {
        ScrollView {
            // Category Filter Pills (Horizontal Scroll)
            if !viewModel.filteredListings.isEmpty {
                categoryPills
                    .padding(.vertical, 12)
            }
            
            if isGridView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.filteredListings) { listing in
                        NavigationLink(destination: ItemDetailViewPlaceholder(listing: listing)) {
                            ListingCard(listing: listing)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.filteredListings) { listing in
                        NavigationLink(destination: ItemDetailViewPlaceholder(listing: listing)) {
                            ListingRow(listing: listing)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var categoryPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                CategoryPill(title: "All", isSelected: viewModel.selectedCategory == nil) {
                    withAnimation {
                        viewModel.selectedCategory = nil
                    }
                }
                
                ForEach(ItemCategory.allCases, id: \.self) { category in
                    CategoryPill(title: category.rawValue, isSelected: viewModel.selectedCategory == category) {
                        withAnimation {
                            viewModel.selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            Text("No listings found")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            Text("Try adjusting your filters or search terms")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if viewModel.selectedCategory != nil || !viewModel.searchText.isEmpty {
                Button("Clear Filters") {
                    withAnimation {
                        viewModel.clearFilters()
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Components

struct ListingRow: View {
    let listing: Listing
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Image Placeholder
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                )
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    if listing.isFeatured {
                        Text("FEATURED")
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(4)
                    }
                    Spacer()
                    Text(listing.createdAt, style: .date)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Text(listing.title)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.primary)
                
                Text(String(format: "€%.2f", listing.price))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Spacer()
                
                HStack {
                    Image(systemName: "tag.fill")
                        .font(.caption2)
                    Text(listing.category.rawValue)
                        .font(.caption)
                    Spacer()
                    Text(listing.sellerName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .foregroundColor(.secondary)
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct ListingCard: View {
    let listing: Listing
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray.opacity(0.5))
                    )
                
                if listing.isFeatured {
                    Image(systemName: "star.circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, .yellow)
                        .font(.title2)
                        .padding(8)
                        .shadow(radius: 2)
                }
            }
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(listing.category.rawValue.uppercased())
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    
                    Text(listing.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(height: 40, alignment: .topLeading)
                        .foregroundColor(.primary)
                }
                
                Text(String(format: "€%.2f", listing.price))
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .padding(12)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct CategoryPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemBackground))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.2), lineWidth: isSelected ? 0 : 1)
                )
        }
    }
}

// Temporary Placeholder for Navigation
struct ItemDetailViewPlaceholder: View {
    let listing: Listing
    
    var body: some View {
        VStack {
            Text("Details for \(listing.title)")
            Text("Coming Soon (Mouhamad's Task)")
                .foregroundColor(.secondary)
        }
        .navigationTitle("Item Details")
    }
}

#Preview {
    FeedView()
}
