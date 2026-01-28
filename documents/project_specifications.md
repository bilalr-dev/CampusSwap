# CampusSwap Project Specifications

## 1. Project Overview
**CampusSwap** is a dedicated iOS marketplace application designed for university students to buy, sell, and trade items (textbooks, furniture, notes, etc.) within their campus community. The app focuses on trust, simplicity, and campus-specific relevance.

## 2. Technical Architecture
*   **Platform**: iOS 16.0+ (Target)
*   **Language**: Swift 5.9+
*   **UI Framework**: SwiftUI
*   **Architecture Pattern**: MVVM (Model-View-ViewModel)
*   **State Management**: `ObservableObject`, `@StateObject`
*   **Data Persistence**: 
    *   **Listings**: Local JSON file via `FileManager`
    *   **User Profile & Features**: `UserDefaults`

## 3. Core Features & Requirements (MVP)

### A. Authentication & Onboarding
*   **Launch Flow**: App checks for existing user session.
*   **Profile Setup**: Mandatory for new users (Name, Contact).

### B. Marketplace Feed (Home)
*   **Listing Display**: Toggle between Grid and List views.
*   **Search & Filter**: Keyword search and Category tabs.
*   **Featured Items**: Highlighted listings at top of feed.

### C. Item Management (CRUD)
*   **Create Listing**: Form to add new items.
*   **Item Details**: Full description and "Contact Seller" action.
*   **My Listings**: Manage user's own listings (Edit/Delete).

### D. Premium Features
*   **Featured Listings**: Upgrade listing visibility (Mock purchase).
*   **Ad Banners**: Simulated ad placements.

---

## 4. Developer Task Breakdown (4 Team Members)

### 👨‍💻 Bilal - Data Layer & Services
**Focus**: Core infrastructure and data persistence.

#### Tasks:
1.  **Data Models**: Implement `Listing`, `UserProfile`, and `ItemCategory` with `Codable`.
2.  **ListingService**: Create CRUD operations (`load`, `save`, `add`, `delete`, `update`) persisting to `listings.json`.
3.  **UserService**: Manage user session and profile persistence via `UserDefaults`.
4.  **FeaturedService**: Track featured listing states.
5.  **Sample Data**: Generate realistic demo data for presentation.

### 👨‍💻 Aakash - Main Feed Screen
**Focus**: The primary browsing and discovery interface.

#### Tasks:
1.  **FeedView**: Implement main list/grid container.
2.  **View Components**: Build `ListingRowView` (List) and `ListingGridView` (Grid).
3.  **Search & Filter**: Implement search bar binding and category filtering logic in `FeedViewModel`.
4.  **Sorting**: Ensure featured items appear at the top of the feed.

### 👨‍💻 Mouhamad - Item Details & Profile Screens
**Focus**: User flows for item management and identity.

#### Tasks:
1.  **Profile Setup**: Build `ProfileSetupView` for first-time onboarding.
2.  **Item Details**: Develop `ItemDetailView` with "Contact Seller" alert/sheet.
3.  **Profile View**: Create `ProfileView` showing user details and "My Listings" list.
4.  **Listing Management**: Implement `CreateListingView` and `EditListingView` forms with validation.

### 👨‍💻 Helijao - Premium Features & UI Polish
**Focus**: Monetization features and overall user experience.

#### Tasks:
1.  **Premium UI**: Build `FeatureListingView` (Purchase Modal) and `FeaturedBadge` component.
2.  **Monetization**: Implement `AdBannerView` component.
3.  **UI Polish**:
    *   Refine styling, typography, and colors.
    *   Implement empty states (e.g., "No listings found").
    *   Add transitions and animations.
4.  **Error Handling**: Create user-friendly error views.
