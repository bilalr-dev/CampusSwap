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
    
    func login(email: String) {
        // Mock login - in a real app, verify password with backend
        // For now, check if a user with this email exists in UserDefaults or create a dummy one
        // Ideally, we search our "database" (array of users), but here we just simulate success
        // by setting a current user with this email.
        
        let user = UserProfile(
            name: "Campus User", // Placeholder name
            contact: email,
            listings: []
        )
        
        // Simulating a successful login/fetch
        self.currentUser = user
        
        do {
            try saveUser(user)
        } catch {
            print("Login error: \(error.localizedDescription)")
        }
    }
    
    func clearUser() {
        userDefaults.removeObject(forKey: userDefaultsKey)
        self.currentUser = nil
    }
}


