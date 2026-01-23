//
//  ProfileViewModel.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentUser: UserProfile?
    @Published var userListings: [Listing] = []
    @Published var isLoading: Bool = false
    
    // MARK: - Dependencies
    private let userService: UserServiceProtocol
    private let listingService: ListingServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(userService: UserServiceProtocol = UserService.shared,
         listingService: ListingServiceProtocol = ListingService.shared) {
        self.userService = userService
        self.listingService = listingService
        
        setupSubscriptions()
        loadProfile()
    }
    
    // MARK: - Setup
    private func setupSubscriptions() {
        // Observe listing changes to keep "My Listings" updated
        listingService.listingsPublisher
            .sink { [weak self] allListings in
                self?.filterUserListings(from: allListings)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    func loadProfile() {
        self.currentUser = userService.getCurrentUser()
        filterUserListings(from: listingService.listings)
    }
    
    func createListing(title: String, description: String, price: Double, category: ItemCategory) throws {
        guard let user = currentUser else { return }
        
        let newListing = Listing(
            title: title,
            description: description,
            price: price,
            category: category,
            sellerName: user.name,
            sellerContact: user.contact
        )
        
        try listingService.addListing(newListing)
    }
    
    func deleteListing(at offsets: IndexSet) {
        // Map UI index to Listing ID
        let listingsToDelete = offsets.map { userListings[$0] }
        
        for listing in listingsToDelete {
            try? listingService.deleteListing(id: listing.id)
        }
    }
    
    // MARK: - Private Methods
    private func filterUserListings(from allListings: [Listing]) {
        guard let user = currentUser else {
            self.userListings = []
            return
        }
        
        // Filter listings where seller matches current user
        // Note: For MVP we rely on name matching. In production, use User ID.
        self.userListings = allListings.filter { $0.sellerName == user.name }
            .sorted { $0.createdAt > $1.createdAt }
    }
    
    func signOut() {
        userService.clearUser()
        // AppRootView checking standardized UserDefaults will handle view switching
    }
}
