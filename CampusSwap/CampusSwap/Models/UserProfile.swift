//
//  UserProfile.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import Foundation

struct UserProfile: Codable {
    var name: String
    var contact: String
    var listings: [UUID]
    
    init(name: String, contact: String, listings: [UUID] = []) {
        self.name = name
        self.contact = contact
        self.listings = listings
    }
}
