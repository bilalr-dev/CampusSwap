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
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    Spacer()
                        .frame(height: 60)
                    
                    VStack(spacing: 16) {
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .cornerRadius(20)
                        
                        VStack(spacing: 8) {
                            Text("Welcome to CampusSwap")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.primary)
                            
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // Form card
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Your Name")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            TextField("", text: $name, prompt: Text("Enter your name").foregroundColor(.secondary))
                                .textFieldStyle(.plain)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(focusedField == .name ? Color.blue : Color.clear, lineWidth: 2)
                                )
                                .focused($focusedField, equals: .name)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.words)
                                .submitLabel(.next)
                                .onSubmit {
                                    focusedField = .contact
                                }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Contact Information")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            TextField("", text: $contact, prompt: Text("Email or phone number").foregroundColor(.secondary))
                                .textFieldStyle(.plain)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(focusedField == .contact ? Color.blue : Color.clear, lineWidth: 2)
                                )
                                .focused($focusedField, equals: .contact)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .submitLabel(.done)
                                .onSubmit {
                                    if !name.isEmpty && !contact.isEmpty {
                                        saveProfile()
                                    }
                                }
                            
                        }
                    }
                    .padding(24)
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    .padding(.horizontal, 24)
                    
                    // login button
                    Button(action: saveProfile) {
                        HStack {
                            Text("Get Started")
                                .font(.headline)
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: name.isEmpty || contact.isEmpty ? [Color.gray, Color.gray] : [Color.blue, Color.purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: (name.isEmpty || contact.isEmpty) ? Color.clear : Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .disabled(name.isEmpty || contact.isEmpty)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    
                    Spacer()
                        .frame(height: 40)
                }
            }
        }
        .navigationBarHidden(true)
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
        UserService.shared.saveUser(userProfile)
        onComplete()
    }
}

#Preview {
    ProfileSetupView(onComplete: {})
}
