//
//  ProfileViewModel.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var userListings: [Listing] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let listingService: ListingServiceProtocol
    private let userService: UserServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(
        listingService: ListingServiceProtocol = ListingService.shared,
        userService: UserServiceProtocol = UserService.shared
    ) {
        self.listingService = listingService
        self.userService = userService
        
        // Observe listing changes
        listingService.listingsPublisher
            .sink { [weak self] _ in
                self?.loadUserListings()
            }
            .store(in: &cancellables)
        
        loadUserListings()
    }
    
    var currentUser: UserProfile? {
        userService.getCurrentUser()
    }
    
    func loadUserListings() {
        guard let currentUser = currentUser else {
            userListings = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Filter listings to only show current user's listings
        userListings = listingService.listings.filter { listing in
            listing.sellerId == currentUser.id
        }
        .sorted { $0.createdAt > $1.createdAt } // Most recent first
        
        isLoading = false
    }
    
    func createListing(_ listing: Listing) throws {
        guard let currentUser = currentUser else {
            throw AppError.unknown(NSError(domain: "ProfileViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "No user profile found"]))
        }
        
        // Ensure the listing is associated with the current user
        var newListing = listing
        newListing.sellerId = currentUser.id
        newListing.sellerName = currentUser.name
        newListing.sellerContact = currentUser.contact
        
        try listingService.addListing(newListing)
        
        // Update user's listing IDs
        var updatedUser = currentUser
        updatedUser.listings.append(newListing.id)
        try userService.saveUser(updatedUser)
        
        loadUserListings()
    }
    
    func updateListing(_ listing: Listing) throws {
        guard let currentUser = currentUser else {
            throw AppError.unknown(NSError(domain: "ProfileViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "No user profile found"]))
        }
        
        // Ensure the listing still belongs to the current user
        guard listing.sellerId == currentUser.id else {
            throw AppError.unknown(NSError(domain: "ProfileViewModel", code: 2, userInfo: [NSLocalizedDescriptionKey: "Cannot update listing that doesn't belong to you"]))
        }
        
        var updatedListing = listing
        // Preserve seller info
        updatedListing.sellerId = currentUser.id
        updatedListing.sellerName = currentUser.name
        updatedListing.sellerContact = currentUser.contact
        
        try listingService.updateListing(updatedListing)
        loadUserListings()
    }
    
    func deleteListing(id: UUID) throws {
        guard let currentUser = currentUser else {
            throw AppError.unknown(NSError(domain: "ProfileViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "No user profile found"]))
        }
        
        // Verify ownership
        guard let listing = listingService.getListing(by: id),
              listing.sellerId == currentUser.id else {
            throw AppError.unknown(NSError(domain: "ProfileViewModel", code: 2, userInfo: [NSLocalizedDescriptionKey: "Cannot delete listing that doesn't belong to you"]))
        }
        
        try listingService.deleteListing(id: id)
        
        // Update user's listing IDs
        var updatedUser = currentUser
        updatedUser.listings.removeAll { $0 == id }
        try userService.saveUser(updatedUser)
        
        loadUserListings()
    }
    
    func deleteListings(at offsets: IndexSet) {
        for index in offsets {
            let listing = userListings[index]
            do {
                try deleteListing(id: listing.id)
            } catch {
                errorMessage = "Failed to delete listing: \(error.localizedDescription)"
            }
        }
    }
}
