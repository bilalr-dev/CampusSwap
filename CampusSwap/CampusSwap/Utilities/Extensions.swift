//
//  Extensions.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import Foundation

extension Date {
    func formatted() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}

extension Double {
    func formattedPrice() -> String {
        return String(format: "€%.2f", self)
    }
}
