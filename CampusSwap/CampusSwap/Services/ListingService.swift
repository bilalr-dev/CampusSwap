//
//  ListingService.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import Foundation
import Combine

// MARK: - Protocol
protocol ListingServiceProtocol {
    var listings: [Listing] { get }
    var listingsPublisher: Published<[Listing]>.Publisher { get }
    
    func loadListings()
    func addListing(_ listing: Listing) throws
    func updateListing(_ listing: Listing) throws
    func deleteListing(id: UUID) throws
    func getListing(by id: UUID) -> Listing?
}

// MARK: - Service Implementation
class ListingService: ObservableObject, ListingServiceProtocol {
    static let shared = ListingService()
    
    @Published var listings: [Listing] = []
    
    var listingsPublisher: Published<[Listing]>.Publisher { $listings }
    
    private let fileName = "listings.json"
    
    // Dependencies (could be injected)
    private let fileManager = FileManager.default
    private let featuredService = FeaturedService.shared
    
    private init() {
        loadListings()
    }
    
    // MARK: - Persistence Paths
    
    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private var fileURL: URL {
        documentsDirectory.appendingPathComponent(fileName)
    }
    
    // MARK: - CRUD Operations
    
    func loadListings() {
        guard fileManager.fileExists(atPath: fileURL.path) else {
            self.listings = []
            return
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            self.listings = try decoder.decode([Listing].self, from: data)
        } catch {
            print("ListingService: Failed to load listings - \(error.localizedDescription)")
            self.listings = []
        }
    }
    
    private func saveListings() throws {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(listings)
            try data.write(to: fileURL)
        } catch {
            throw AppError.encodingFailed
        }
    }
    
    func addListing(_ listing: Listing) throws {
        listings.append(listing)
        try saveListings()
    }
    
    func updateListing(_ listing: Listing) throws {
        guard let index = listings.firstIndex(where: { $0.id == listing.id }) else {
            return
        }
        
        var updatedListing = listing
        // Ensure featured status is synced with FeaturedService
        updatedListing.isFeatured = featuredService.isFeatured(id: listing.id)
        
        listings[index] = updatedListing
        try saveListings()
    }
    
    func deleteListing(id: UUID) throws {
        listings.removeAll { $0.id == id }
        try saveListings()
    }
    
    func getListing(by id: UUID) -> Listing? {
        listings.first { $0.id == id }
    }
}
