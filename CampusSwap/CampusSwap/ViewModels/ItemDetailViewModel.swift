//
//  ItemDetailViewModel.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import Foundation
import Combine

class ItemDetailViewModel: ObservableObject {
    // MARK: - Published Properties,
    @Published var listing: Listing
    @Published var isCurrentUserSeller: Bool = false
    @Published var sellerProfile: UserProfile?
    @Published var showingContactInfo: Bool = false
    
    // MARK: - Dependencies
    private let userService: UserServiceProtocol
    private let featuredService: FeaturedServiceProtocol
    private let listingService: ListingServiceProtocol
    
    // MARK: - Initialization
    init(listing: Listing,
         userService: UserServiceProtocol = UserService.shared,
         featuredService: FeaturedServiceProtocol = FeaturedService.shared,
         listingService: ListingServiceProtocol = ListingService.shared) {
        self.listing = listing
        self.userService = userService
        self.featuredService = featuredService
        self.listingService = listingService
        
        checkIfCurrentUser()
    }
    
    // MARK: - Public Methods
    func checkIfCurrentUser() {
        self.isCurrentUserSeller = userService.isCurrentUser(sellerName: listing.sellerName)
    }
    
    // Refresh listing data (e.g. if featured status changed)
    func refreshListing() {
        if let updatedListing = listingService.getListing(by: listing.id) {
            self.listing = updatedListing
        }
    }
    
    func deleteListing() {
        try? listingService.deleteListing(id: listing.id)
    }
}
