//
//  UserService.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import Foundation
import Combine

protocol UserServiceProtocol {
    func getCurrentUser() -> UserProfile?
    func saveUser(_ user: UserProfile) throws
    func isCurrentUser(sellerId: UUID) -> Bool
    func clearUser()
}

class UserService: ObservableObject, UserServiceProtocol {
    static let shared = UserService()
    
    private let userDefaultsKey = "currentUser"
    private let userDefaults = UserDefaults.standard
    
    // Cache the user in memory to avoid frequent UserDefaults reads
    @Published private(set) var currentUser: UserProfile?
    
    private init() {
        self.currentUser = loadUserFromDefaults()
    }
    
    private func loadUserFromDefaults() -> UserProfile? {
        guard let data = userDefaults.data(forKey: userDefaultsKey) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(UserProfile.self, from: data)
        } catch {
            print("UserService: Failed to decode user profile - \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Protocol Methods
    
    func getCurrentUser() -> UserProfile? {
        return currentUser
    }
    
    func saveUser(_ user: UserProfile) throws {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(user)
            userDefaults.set(data, forKey: userDefaultsKey)
            
            // Update cache
            self.currentUser = user
        } catch {
            throw AppError.encodingFailed
        }
    }
    
    func isCurrentUser(sellerId: UUID) -> Bool {
        guard let currentUser = currentUser else {
            return false
        }
        return currentUser.id == sellerId
    }
    
    func clearUser() {
        userDefaults.removeObject(forKey: userDefaultsKey)
        self.currentUser = nil
    }
}


