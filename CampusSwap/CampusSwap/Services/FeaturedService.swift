//
//  FeaturedService.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import Foundation
import Combine

protocol FeaturedServiceProtocol {
    func isFeatured(id: UUID) -> Bool
    func setFeatured(id: UUID, isFeatured: Bool)
    func getFeaturedIds() -> [UUID]
}

class FeaturedService: ObservableObject, FeaturedServiceProtocol {
    static let shared = FeaturedService()
    
    private let featuredIdsKey = "featuredListingIds"
    private let userDefaults = UserDefaults.standard
    
    // In-memory cache
    @Published private(set) var featuredIds: [UUID] = []
    
    private init() {
        self.featuredIds = loadFeaturedIds()
    }
    
    private func loadFeaturedIds() -> [UUID] {
        guard let data = userDefaults.data(forKey: featuredIdsKey) else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([UUID].self, from: data)
        } catch {
            print("FeaturedService: Failed to decode featured IDs - \(error.localizedDescription)")
            return []
        }
    }
    
    func isFeatured(id: UUID) -> Bool {
        return featuredIds.contains(id)
    }
    
    func setFeatured(id: UUID, isFeatured: Bool) {
        if isFeatured {
            if !featuredIds.contains(id) {
                featuredIds.append(id)
            }
        } else {
            featuredIds.removeAll { $0 == id }
        }
        
        saveFeaturedIds(featuredIds)
    }
    
    func getFeaturedIds() -> [UUID] {
        return featuredIds
    }
    
    private func saveFeaturedIds(_ ids: [UUID]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(ids)
            userDefaults.set(data, forKey: featuredIdsKey)
        } catch {
            print("FeaturedService: Failed to save featured IDs - \(error.localizedDescription)")
            // Since this is a void method and usually triggered by UI action, we log but don't crash.
            // In a stricter clean arch, we might want to propagate this, but for MVP local storage, logging is acceptable here.
        }
    }
}
