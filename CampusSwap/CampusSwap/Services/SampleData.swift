//
//  SampleData.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import Foundation

class SampleData {
    static func createSampleListings() -> [Listing] {
        return [
            Listing(
                title: "Introduction to Algorithms - 4th Edition",
                description: "Excellent condition, barely used. Perfect for CS students. Includes all chapters.",
                price: 45.00,
                category: .textbook,
                sellerName: "Alex Martin",
                sellerContact: "alex.martin@epita.fr",
                isFeatured: true,
                createdAt: Date().addingTimeInterval(-86400 * 2)
            ),
            Listing(
                title: "Computer Networks - Tanenbaum",
                description: "5th edition, good condition. Some highlighting in first few chapters.",
                price: 35.00,
                category: .textbook,
                sellerName: "Sarah Chen",
                sellerContact: "sarah.chen@epita.fr",
                isFeatured: false,
                createdAt: Date().addingTimeInterval(-86400 * 5)
            ),
            Listing(
                title: "Office Desk Chair",
                description: "Ergonomic office chair, adjustable height. Great for studying at home.",
                price: 60.00,
                category: .furniture,
                sellerName: "Thomas Dubois",
                sellerContact: "thomas.dubois@epita.fr",
                isFeatured: true,
                createdAt: Date().addingTimeInterval(-86400 * 1)
            ),
            Listing(
                title: "Data Structures & Algorithms Notes",
                description: "Comprehensive notes from DSA course. Includes diagrams, code examples, and exam tips.",
                price: 15.00,
                category: .notes,
                sellerName: "Emma Laurent",
                sellerContact: "emma.laurent@epita.fr",
                isFeatured: false,
                createdAt: Date().addingTimeInterval(-86400 * 3)
            ),
            Listing(
                title: "Operating Systems Concepts - Silberschatz",
                description: "10th edition, like new. No markings or highlights.",
                price: 50.00,
                category: .textbook,
                sellerName: "Lucas Moreau",
                sellerContact: "lucas.moreau@epita.fr",
                isFeatured: false,
                createdAt: Date().addingTimeInterval(-86400 * 7)
            ),
            Listing(
                title: "Study Desk",
                description: "Wooden desk with drawers. Perfect size for dorm room. Some minor scratches.",
                price: 80.00,
                category: .furniture,
                sellerName: "Sophie Bernard",
                sellerContact: "sophie.bernard@epita.fr",
                isFeatured: false,
                createdAt: Date().addingTimeInterval(-86400 * 4)
            ),
            Listing(
                title: "Database Systems Notes",
                description: "Complete notes from Database course. Covers SQL, normalization, transactions.",
                price: 12.00,
                category: .notes,
                sellerName: "Hugo Petit",
                sellerContact: "hugo.petit@epita.fr",
                isFeatured: false,
                createdAt: Date().addingTimeInterval(-86400 * 6)
            ),
            Listing(
                title: "Software Engineering Textbook",
                description: "Clean copy, no highlights. Perfect for SE course.",
                price: 40.00,
                category: .textbook,
                sellerName: "Marie Rousseau",
                sellerContact: "marie.rousseau@epita.fr",
                isFeatured: true,
                createdAt: Date().addingTimeInterval(-86400 * 2)
            )
        ]
    }
    
    static func createSampleUser() -> UserProfile {
        return UserProfile(
            name: "Demo User",
            contact: "demo@epita.fr",
            listings: []
        )
    }
}
