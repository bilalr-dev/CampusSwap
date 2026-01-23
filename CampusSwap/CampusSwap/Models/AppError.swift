//
//  AppError.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import Foundation

enum AppError: LocalizedError {
    case fileNotFound
    case decodingFailed
    case encodingFailed
    case dataCorrupted
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "The requested file could not be found."
        case .decodingFailed:
            return "Failed to process the data from storage."
        case .encodingFailed:
            return "Failed to save the data to storage."
        case .dataCorrupted:
            return "The data appears to be corrupted."
        case .unknown(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}
