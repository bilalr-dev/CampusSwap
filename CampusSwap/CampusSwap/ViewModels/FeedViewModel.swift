//
//  FeedViewModel.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import Foundation
import Combine

class FeedViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var searchText: String = ""
    @Published var selectedCategory: ItemCategory? = nil
    @Published var isGridView: Bool = false
    
    // Private storage for all listings
    @Published private var allListings: [Listing] = []
    
    // Dependencies
    private let listingService: ListingServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(listingService: ListingServiceProtocol = ListingService.shared) {
        self.listingService = listingService
        
        // Subscribe to listings updates
        listingService.listingsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] listings in
                self?.allListings = listings
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Computed Properties
    
    var filteredListings: [Listing] {
        var result = allListings
        
        // 1. Filter by Category
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        // 2. Filter by Search Text
        if !searchText.isEmpty {
            let lowercasedQuery = searchText.lowercased()
            result = result.filter { listing in
                listing.title.lowercased().contains(lowercasedQuery) ||
                listing.description.lowercased().contains(lowercasedQuery)
            }
        }
        
        // 3. Sort: Featured first, then Newest first
        result.sort { first, second in
            if first.isFeatured && !second.isFeatured {
                return true
            } else if !first.isFeatured && second.isFeatured {
                return false
            } else {
                return first.createdAt > second.createdAt
            }
        }
        
        return result
    }
    
    var featuredListings: [Listing] {
        allListings.filter { $0.isFeatured }
            .sorted { $0.createdAt > $1.createdAt }
    }
    
    // MARK: - Actions
    
    func toggleViewMode() {
        isGridView.toggle()
    }
    
    func clearFilters() {
        searchText = ""
        selectedCategory = nil
    }
    
    func selectCategory(_ category: ItemCategory) {
        if selectedCategory == category {
            selectedCategory = nil // Deselect if tapping same category
        } else {
            selectedCategory = category
        }
    }
}
