//
//  EditListingView.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import SwiftUI

struct EditListingView: View {
    let listing: Listing
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ProfileViewModel()
    
    @State private var title: String
    @State private var description: String
    @State private var price: String
    @State private var selectedCategory: ItemCategory
    @State private var showingError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isSaving: Bool = false
    @State private var showingDeleteConfirmation: Bool = false
    
    init(listing: Listing) {
        self.listing = listing
        _title = State(initialValue: listing.title)
        _description = State(initialValue: listing.description)
        _price = State(initialValue: String(format: "%.2f", listing.price))
        _selectedCategory = State(initialValue: listing.category)
    }
    
    var body: some View {
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
            
            Section {
                Button(role: .destructive, action: { showingDeleteConfirmation = true }) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete Listing")
                    }
                }
            }
        }
        .navigationTitle("Edit Listing")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    updateListing()
                }
                .disabled(!isFormValid || isSaving)
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .confirmationDialog("Delete Listing", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                deleteListing()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this listing? This action cannot be undone.")
        }
    }
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !description.trimmingCharacters(in: .whitespaces).isEmpty &&
        !price.trimmingCharacters(in: .whitespaces).isEmpty &&
        Double(price) != nil &&
        Double(price)! > 0
    }
    
    private func updateListing() {
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
        
        isSaving = true
        
        var updatedListing = listing
        updatedListing.title = title.trimmingCharacters(in: .whitespaces)
        updatedListing.description = description.trimmingCharacters(in: .whitespaces)
        updatedListing.price = priceValue
        updatedListing.category = selectedCategory
        
        do {
            try viewModel.updateListing(updatedListing)
            dismiss()
        } catch {
            errorMessage = "Failed to update listing: \(error.localizedDescription)"
            showingError = true
            isSaving = false
        }
    }
    
    private func deleteListing() {
        do {
            try viewModel.deleteListing(id: listing.id)
            dismiss()
        } catch {
            errorMessage = "Failed to delete listing: \(error.localizedDescription)"
            showingError = true
        }
    }
}

#Preview {
    NavigationStack {
        EditListingView(listing: Listing(
            title: "Sample Listing",
            description: "This is a sample description",
            price: 25.99,
            category: .textbook,
            sellerId: UUID(),
            sellerName: "John Doe",
            sellerContact: "john@example.com"
        ))
    }
}
