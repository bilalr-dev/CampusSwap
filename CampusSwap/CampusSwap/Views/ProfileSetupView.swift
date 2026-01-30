//
//  ProfileSetupView.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import SwiftUI

struct ProfileSetupView: View {
    @State private var name: String = ""
    @State private var contact: String = ""
    @State private var showingError: Bool = false
    @State private var errorMessage: String = ""
    
    @ObservedObject private var userService = UserService.shared
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Logo/Header
                VStack(spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                    
                    Text("Welcome to CampusSwap")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Set up your profile to get started")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 60)
                
                // Form
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Enter your name", text: $name)
                            .textFieldStyle(.roundedBorder)
                            .autocapitalization(.words)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Contact")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Email or phone number", text: $contact)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        Text("This will be shared when buyers contact you")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Get Started Button
                Button(action: saveProfile) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color.blue : Color.gray)
                        .cornerRadius(12)
                }
                .disabled(!isFormValid)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !contact.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private func saveProfile() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        let trimmedContact = contact.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedName.isEmpty && !trimmedContact.isEmpty else {
            errorMessage = "Please fill in all fields"
            showingError = true
            return
        }
        
        let userProfile = UserProfile(
            name: trimmedName,
            contact: trimmedContact,
            listings: []
        )
        
        do {
            try userService.saveUser(userProfile)
        } catch {
            errorMessage = "Failed to save profile: \(error.localizedDescription)"
            showingError = true
        }
    }
}

#Preview {
    ProfileSetupView()
}
