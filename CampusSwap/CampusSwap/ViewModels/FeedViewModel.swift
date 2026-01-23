//
//  FeedViewModel.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import Foundation
import Combine
import SwiftUI

class FeedViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var filteredListings: [Listing] = []
    @Published var searchText: String = ""
    @Published var selectedCategory: ItemCategory? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    private let listingService: ListingServiceProtocol
    private let featuredService: FeaturedServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(listingService: ListingServiceProtocol = ListingService.shared,
         featuredService: FeaturedServiceProtocol = FeaturedService.shared) {
        self.listingService = listingService
        self.featuredService = featuredService
        
        setupSubscriptions()
        // Load initial data
        refresh()
    }
    
    // MARK: - Setup
    private func setupSubscriptions() {
        // Observe listing changes from service
        listingService.listingsPublisher
            .sink { [weak self] _ in
                self?.filterAndSortListings()
            }
            .store(in: &cancellables)
        
        // Observe search text and category changes
        Publishers.CombineLatest3($searchText, $selectedCategory, listingService.listingsPublisher)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _, _, _ in
                self?.filterAndSortListings()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    func refresh() {
        isLoading = true
        errorMessage = nil
        
        listingService.loadListings()
        
        // Check if empty (first run), inject sample data if needed (Logic for MVP)
        if listingService.listings.isEmpty {
            let samples = SampleData.createSampleListings()
            for item in samples {
                try? listingService.addListing(item)
            }
        }
        
        // Small delay to simulate refresh if needed, or just let the publisher update
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.isLoading = false
        }
    }
    
    // MARK: - Filtering & Sorting
    private func filterAndSortListings() {
        let allListings = listingService.listings
        
        // 1. Filter
        var result = allListings.filter { listing in
            // Search Text Filter
            let matchesSearch = searchText.isEmpty || 
                listing.title.localizedCaseInsensitiveContains(searchText) ||
                listing.description.localizedCaseInsensitiveContains(searchText)
            
            // Category Filter
            let matchesCategory = selectedCategory == nil || listing.category == selectedCategory
            
            return matchesSearch && matchesCategory
        }
        
        // 2. Sort
        result.sort { first, second in
            // Featured first
            if first.isFeatured != second.isFeatured {
                return first.isFeatured && !second.isFeatured
            }
            
            // Then newest first
            return first.createdAt > second.createdAt
        }
        
        self.filteredListings = result
    }
    
    func clearFilters() {
        searchText = ""
        selectedCategory = nil
    }
}
