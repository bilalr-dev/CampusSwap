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
    @State private var showingError = false
    @State private var errorMessage = ""
    @FocusState private var focusedField: Field?
    
    let onComplete: () -> Void
    
    enum Field {
        case name, contact
    }
    
    var body: some View {
    var body: some View {
        ZStack {
            // Animated Background Gradient
            LinearGradient(
                colors: [Color.blue, Color.purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .opacity(0.8)
            
            ScrollView {
                VStack(spacing: 40) {
                    Spacer()
                        .frame(height: 40)
                    
                    // Logo & Welcome
                    VStack(spacing: 16) {
                        Image(systemName: "graduationcap.circle.fill") // Using symbol for now if Asset not ready
                            .resizable()
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .white.opacity(0.3))
                            .frame(width: 100, height: 100)
                            .shadow(radius: 10)
                        
                        Text("CampusSwap")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Connect. Trade. Thrive.")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.bottom, 20)
                    
                    // Fields Container
                    VStack(spacing: 20) {
                        // Name Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("FULL NAME")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.leading, 4)
                            
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white.opacity(0.6))
                                TextField("", text: $name, prompt: Text("Your Name").foregroundColor(.white.opacity(0.5)))
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                        }
                        
                        // Contact Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("CONTACT INFO")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.leading, 4)
                            
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.white.opacity(0.6))
                                TextField("", text: $contact, prompt: Text("Email or Phone").foregroundColor(.white.opacity(0.5)))
                                    .foregroundColor(.white)
                                    .keyboardType(.emailAddress)
                            }
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // Action Button
                    Button(action: saveProfile) {
                        HStack {
                            Text("Start Exploring")
                                .font(.headline)
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(name.isEmpty || contact.isEmpty ? .gray : .blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    }
                    .disabled(name.isEmpty || contact.isEmpty)
                    .padding(.horizontal, 32)
                    .opacity(name.isEmpty || contact.isEmpty ? 0.6 : 1.0)
                    .animation(.easeInOut, value: name.isEmpty || contact.isEmpty)
                    
                    Spacer()
                }
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func saveProfile() {
        guard !name.isEmpty, name.count >= 2 else {
            errorMessage = "Please enter a valid name (at least 2 characters)"
            showingError = true
            return
        }
        
        guard !contact.isEmpty else {
            errorMessage = "Please enter your contact information"
            showingError = true
            return
        }
        
        let userProfile = UserProfile(name: name, contact: contact, listings: [])
        
        do {
            try UserService.shared.saveUser(userProfile)
            onComplete()
        } catch {
            errorMessage = "Failed to save profile: \(error.localizedDescription)"
            showingError = true
        }
    }
}

#Preview {
    ProfileSetupView(onComplete: {})
}
