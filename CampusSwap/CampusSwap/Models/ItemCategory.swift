//
//  ItemCategory.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import Foundation

enum ItemCategory: String, Codable, CaseIterable {
    case textbook = "Textbook"
    case furniture = "Furniture"
    case notes = "Notes"
    
    var icon: String {
        switch self {
        case .textbook:
            return "book.fill"
        case .furniture:
            return "sofa.fill"
        case .notes:
            return "doc.text.fill"
        }
    }
}
