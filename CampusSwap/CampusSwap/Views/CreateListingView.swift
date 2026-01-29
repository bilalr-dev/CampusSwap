//
//  CreateListingView.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import SwiftUI

struct CreateListingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ProfileViewModel()
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var price: String = ""
    @State private var selectedCategory: ItemCategory = .textbook
    @State private var showingError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isSaving: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Item Information") {
                    TextField("Title", text: $title)
                        .autocapitalization(.words)
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(ItemCategory.allCases, id: \.self) { category in
                            HStack {
                                Image(systemName: category.icon)
                                Text(category.rawValue)
                            }
                            .tag(category)
                        }
                    }
                    
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        
                        TextEditor(text: $description)
                            .frame(minHeight: 120)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Create Listing")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveListing()
                    }
                    .disabled(!isFormValid || isSaving)
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !description.trimmingCharacters(in: .whitespaces).isEmpty &&
        !price.trimmingCharacters(in: .whitespaces).isEmpty &&
        Double(price) != nil &&
        Double(price)! > 0
    }
    
    private func saveListing() {
        guard isFormValid else {
            errorMessage = "Please fill in all fields correctly"
            showingError = true
            return
        }
        
        guard let priceValue = Double(price), priceValue > 0 else {
            errorMessage = "Please enter a valid price"
            showingError = true
            return
        }
        
        guard let currentUser = viewModel.currentUser else {
            errorMessage = "User profile not found"
            showingError = true
            return
        }
        
        isSaving = true
        
        let newListing = Listing(
            title: title.trimmingCharacters(in: .whitespaces),
            description: description.trimmingCharacters(in: .whitespaces),
            price: priceValue,
            category: selectedCategory,
            sellerId: currentUser.id,
            sellerName: currentUser.name,
            sellerContact: currentUser.contact,
            isFeatured: false
        )
        
        do {
            try viewModel.createListing(newListing)
            dismiss()
        } catch {
            errorMessage = "Failed to create listing: \(error.localizedDescription)"
            showingError = true
            isSaving = false
        }
    }
}

#Preview {
    CreateListingView()
}
