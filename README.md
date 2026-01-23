# CampusSwap

A hyper-local marketplace mobile application designed for university students to buy, sell, and trade textbooks, furniture, and course notes within their campus community.

## Overview

CampusSwap addresses the financial burden students face when purchasing new course materials and provides an efficient, cost-effective solution for peer-to-peer transactions. The app connects students within the same university or nearby campuses, eliminating shipping costs through local meetups.

## Problem & Solution

**Problem**: Students spend too much on new textbooks and struggle to sell used items due to shipping costs and lack of local buyers.

**Solution**: A hyper-local marketplace app specifically for university students (EPITA and nearby) to buy, sell, and trade items within their campus community.

## Target Users

- **Primary**: University students at EPITA and nearby universities in the Paris region
- **Use Cases**: 
  - Buying used textbooks at lower prices
  - Selling textbooks after semester ends
  - Trading items with other students
  - Finding furniture for dorms/apartments
  - Sharing/selling class notes

## Features

- **Profile Setup**: First-time user onboarding with name and contact information
- **Browse Listings**: View all available items (currently in development)
- **Create Listings**: Post items for sale with details (currently in development)
- **Item Details**: View complete item information (currently in development)
- **User Profile**: Manage your own listings (currently in development)
- **Search & Filter**: Find items by keyword, category, and price range (planned)
- **Featured Listings**: Premium feature to boost listing visibility (planned)
- **Ad Placements**: Non-intrusive banner ads for local businesses (planned)

## Technical Stack

- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **iOS Version**: iOS 16.0+
- **Data Storage**: 
  - JSON file (`listings.json`) for listings data
  - UserDefaults for user profile and featured listings
- **Architecture**: MVVM (Model-View-ViewModel)
- **No External Dependencies**: Pure Apple native frameworks only

## Project Structure

```
CampusSwap/
├── CampusSwapApp.swift          # App entry point with profile check
├── Models/
│   ├── Listing.swift            # Listing data model
│   ├── UserProfile.swift        # User data model
│   └── ItemCategory.swift       # Category enumeration
├── Views/
│   ├── ProfileSetupView.swift   # First-time user setup (Screen 0)
│   ├── ContentView.swift        # Main tab container
│   ├── FeedView.swift           # Browse listings (Screen 1)
│   └── ProfileView.swift        # User's listings (Screen 3)
├── ViewModels/
│   ├── FeedViewModel.swift      # Feed screen logic (placeholder)
│   └── ProfileViewModel.swift  # Profile screen logic (placeholder)
├── Services/
│   ├── ListingService.swift     # Listing CRUD operations
│   ├── UserService.swift        # User profile management
│   ├── FeaturedService.swift    # Featured listing tracking
│   └── SampleData.swift         # Sample data generator
├── Utilities/
│   └── Extensions.swift         # Helper extensions
└── Assets.xcassets/
    └── Logo.imageset/           # App logo
```

## Current Implementation Status

### Completed
- Profile Setup Screen (Screen 0) - First-time user onboarding
- Data Models (Listing, UserProfile, ItemCategory)
- Services Layer (ListingService, UserService, FeaturedService)
- Basic Navigation Structure

### In Progress / Planned
- Main Feed Screen (Screen 1) - Browse listings
- Item Details Screen (Screen 2) - View item details
- User Profile Screen (Screen 3) - Manage listings
- Search & Filter functionality
- Featured listings feature
- Ad placements

## Setup Instructions

1. **Clone the repository**:
   ```bash
   git clone https://github.com/bilalr-dev/CampusSwap.git
   cd CampusSwap
   ```

2. **Open in Xcode**:
   - Open `CampusSwap.xcodeproj` in Xcode
   - Select a simulator or device
   - Build and run (⌘R)

3. **First Launch**:
   - On first launch, you'll see the Profile Setup screen
   - Enter your name and contact information
   - After setup, you'll see the main app with Feed and Profile tabs

## Business Model

- **Freemium**: Basic listings are free; featured listings cost €2-5
- **Advertising**: Banner ads for local student-friendly businesses

See [BUSINESS_CASE.md](documents/BUSINESS_CASE.md) for detailed business information.

## Quick Navigation / Documentation

- **[Business Case](documents/BUSINESS_CASE.md)**: Monetization strategy and market analysis
- **[Technical Architecture](documents/TECHNICAL_ARCHITECTURE.md)**: System design and diagrams
- **[Feature Specifications](documents/FEATURES.md)**: Detailed feature breakdown
- **[Project Plan](documents/PROJECT_PLAN.md)**: Development timeline and milestones

## Team

This is a group project for EPITA iOS and Swift Fundamentals course.

**Team Size**: 4 members

**Deadline**: February 2nd, 2025

## Contributing

This is a group project. All team members should:
- Work on feature branches (`feature/[feature-name]`)
- Create pull requests for review
- Follow Swift style guidelines
- Write clean, readable code
- Commit regularly with clear messages

## License

This project is part of an EPITA iOS and Swift Fundamentals course assignment.

---**Repository**: [https://github.com/bilalr-dev/CampusSwap](https://github.com/bilalr-dev/CampusSwap)
