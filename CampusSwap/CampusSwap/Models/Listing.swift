//
//  Listing.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import Foundation

struct Listing: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var price: Double
    var category: ItemCategory
    var sellerId: UUID
    var sellerName: String
    var sellerContact: String
    var isFeatured: Bool
    var createdAt: Date
    var imageName: String?
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        price: Double,
        category: ItemCategory,
        sellerId: UUID,
        sellerName: String,
        sellerContact: String,
        isFeatured: Bool = false,
        createdAt: Date = Date(),
        imageName: String? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.category = category
        self.sellerId = sellerId
        self.sellerName = sellerName
        self.sellerContact = sellerContact
        self.isFeatured = isFeatured
        self.createdAt = createdAt
        self.imageName = imageName
    }
}
