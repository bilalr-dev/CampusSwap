//
//  UserProfile.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import Foundation

struct UserProfile: Codable, Identifiable {
    var id: UUID
    var name: String
    var contact: String
    var listings: [UUID]
    
    init(id: UUID = UUID(), name: String, contact: String, listings: [UUID] = []) {
        self.id = id
        self.name = name
        self.contact = contact
        self.listings = listings
    }
}
