//
//  CreateListingView.swift
//  CampusSwap
//
//  Created by CampusSwap Team
//

import SwiftUI

struct CreateListingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ProfileViewModel() // Reusing ProfileViewModel for creation logic
    
    @State private var title = ""
    @State private var description = ""
    @State private var priceString = ""
    @State private var selectedCategory: ItemCategory = .textbook
    
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Item Details")) {
                    TextField("Title", text: $title)
                    TextField("Price (€)", text: $priceString)
                        .keyboardType(.decimalPad)
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(ItemCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                }
                
                Section(header: Text("Description")) {
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
            }
            .navigationTitle("New Listing")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Post") {
                       saveListing()
                    }
                    .disabled(title.isEmpty || priceString.isEmpty || description.isEmpty)
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func saveListing() {
        guard let price = Double(priceString), price >= 0 else {
            errorMessage = "Please enter a valid price."
            showingError = true
            return
        }
        
        do {
            try viewModel.createListing(
                title: title,
                description: description,
                price: price,
                category: selectedCategory
            )
            dismiss()
        } catch {
            errorMessage = "Failed to post listing: \(error.localizedDescription)"
            showingError = true
        }
    }
}

#Preview {
    CreateListingView()
}
