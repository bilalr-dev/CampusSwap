//
//  ItemDetailViewModel.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import Foundation
import Combine

class ItemDetailViewModel: ObservableObject {
    @Published var listing: Listing?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showingContactInfo: Bool = false
    
    private let listingService: ListingServiceProtocol
    private let userService: UserServiceProtocol
    private let featuredService: FeaturedServiceProtocol
    
    init(
        listing: Listing? = nil,
        listingService: ListingServiceProtocol = ListingService.shared,
        userService: UserServiceProtocol = UserService.shared,
        featuredService: FeaturedServiceProtocol = FeaturedService.shared
    ) {
        self.listing = listing
        self.listingService = listingService
        self.userService = userService
        self.featuredService = featuredService
    }
    
    func loadListing(id: UUID) {
        isLoading = true
        errorMessage = nil
        
        if let loadedListing = listingService.getListing(by: id) {
            // Sync featured status
            var updatedListing = loadedListing
            updatedListing.isFeatured = featuredService.isFeatured(id: id)
            self.listing = updatedListing
        } else {
            errorMessage = "Listing not found"
        }
        
        isLoading = false
    }
    
    var isCurrentUserListing: Bool {
        guard let listing = listing,
              let currentUser = userService.getCurrentUser() else {
            return false
        }
        return listing.sellerId == currentUser.id
    }
    
    var contactInfo: String? {
        listing?.sellerContact
    }
    
    var sellerName: String {
        listing?.sellerName ?? "Unknown"
    }
    
    func showContactInfo() {
        showingContactInfo = true
    }
    
    func featureListing() {
        guard let listing = listing else { return }
        featuredService.setFeatured(id: listing.id, isFeatured: true)
        
        // Update local listing
        var updatedListing = listing
        updatedListing.isFeatured = true
        
        // Update in service
        do {
            try listingService.updateListing(updatedListing)
            self.listing = updatedListing
        } catch {
            errorMessage = "Failed to feature listing: \(error.localizedDescription)"
        }
    }
    
    func unfeatureListing() {
        guard let listing = listing else { return }
        featuredService.setFeatured(id: listing.id, isFeatured: false)
        
        // Update local listing
        var updatedListing = listing
        updatedListing.isFeatured = false
        
        // Update in service
        do {
            try listingService.updateListing(updatedListing)
            self.listing = updatedListing
        } catch {
            errorMessage = "Failed to unfeature listing: \(error.localizedDescription)"
        }
    }
}
