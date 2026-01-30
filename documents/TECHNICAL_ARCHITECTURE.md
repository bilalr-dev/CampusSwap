# CampusSwap - Technical Architecture

## Overview

This document describes the technical architecture of the CampusSwap iOS application, including system design, data flow, use cases, and class structure.

**App Name**: CampusSwap  
**Target Platform**: iOS 16.0+  
**Architecture Pattern**: MVVM (Model-View-ViewModel)  
**Language**: Swift 5.9+  
**UI Framework**: SwiftUI  
**No External Dependencies**: Pure Apple native frameworks only

---

## System Architecture

### High-Level Architecture

CampusSwap follows the **MVVM (Model-View-ViewModel)** architectural pattern, which provides clear separation of concerns and makes the codebase maintainable and testable.

```
┌─────────────────────────────────────────────────────────┐
│                    SwiftUI Views                         │
│  (ProfileSetupView, FeedView, ProfileView, etc.)        │
└────────────────────┬────────────────────────────────────┘
                     │ @StateObject, @ObservedObject
                     ▼
┌─────────────────────────────────────────────────────────┐
│                  ViewModels                              │
│  (FeedViewModel, ProfileViewModel)                       │
│  - Business Logic                                        │
│  - State Management                                      │
└────────────────────┬────────────────────────────────────┘
                     │ Uses
                     ▼
┌─────────────────────────────────────────────────────────┐
│                    Services                              │
│  (ListingService, UserService, FeaturedService)          │
│  - Data Access Layer                                     │
│  - Persistence Logic                                     │
└────────────────────┬────────────────────────────────────┘
                     │ Reads/Writes
                     ▼
┌─────────────────────────────────────────────────────────┐
│                  Data Storage                            │
│  - UserDefaults (User Profile, Featured IDs)             │
│  - JSON File (Listings)                                  │
└─────────────────────────────────────────────────────────┘
```

---

## User Flow Diagrams

### Application Launch Flow

```mermaid
flowchart TD
    Start([App Launch]) --> CheckUser{User Profile Exists?}
    CheckUser -->|No| ProfileSetup[Profile Setup Screen]
    CheckUser -->|Yes| ContentView[Main App - TabView]
    ProfileSetup -->|Save Profile| ContentView
    ContentView --> FeedTab[Feed Tab]
    ContentView --> ProfileTab[Profile Tab]
```

### Main User Flows

#### Flow 1: Browse and Buy Items

```mermaid
flowchart TD
    A[Feed Screen] -->|Browse Listings| B{View Mode?}
    B -->|List View| C[List View]
    B -->|Grid View| D[Grid View]
    C -->|Tap Item| E[Item Details Screen]
    D -->|Tap Item| E
    E -->|Contact Seller| F[Show Contact Info]
    E -->|Back| A
    F -->|Close| E
```

#### Flow 2: Create and Sell Items

```mermaid
flowchart TD
    A[Profile Screen] -->|Create Listing| B[Create Listing Form]
    B -->|Fill Form| C{Validate?}
    C -->|Invalid| D[Show Error]
    D --> B
    C -->|Valid| E[Save Listing]
    E -->|Success| F[Return to Profile]
    F -->|View Listing| G[Edit Listing Screen]
    G -->|Update| H[Update Listing]
    G -->|Delete| I[Delete Listing]
    H --> F
    I --> F
```

#### Flow 3: Feature a Listing

```mermaid
flowchart TD
    A[Item Details Screen] -->|Feature Listing| B[Feature Purchase Modal]
    B -->|View Pricing| C{User Confirms?}
    C -->|Cancel| A
    C -->|Purchase| D[Mock Purchase Flow]
    D -->|Processing| E[Loading State]
    E -->|Success| F[Mark as Featured]
    F -->|Update UI| G[Show Featured Badge]
    G -->|Refresh Feed| H[Featured at Top]
```

---

## Data Flow Diagrams

### Data Persistence Flow

```mermaid
flowchart LR
    A[User Action] --> B[ViewModel]
    B --> C[Service Layer]
    C --> D{Data Type?}
    D -->|User Profile| E[UserDefaults]
    D -->|Featured IDs| E
    D -->|Listings| F[JSON File]
    E --> G[Persistence]
    F --> G
    G --> H[Load on App Launch]
```

### Listing Data Flow

```mermaid
flowchart TD
    A[Create Listing] --> B[ProfileViewModel]
    B --> C[ListingService.addListing]
    C --> D[Add to listings array]
    D --> E[Encode to JSON]
    E --> F[Save to listings.json]
    F --> G[Update @Published property]
    G --> H[FeedViewModel observes change]
    H --> I[Update UI]
```

### User Profile Flow

```mermaid
flowchart TD
    A[Profile Setup] --> B[UserService.saveUser]
    B --> C[Encode UserProfile]
    C --> D[Save to UserDefaults]
    D --> E[App detects profile]
    E --> F[Show Main App]
    F --> G[Load profile when needed]
    G --> H[Display user info]
```

---

## Use Case Diagrams

### Primary Use Cases

```mermaid
graph TB
    User[Student User] --> UC1[Browse Listings]
    User --> UC2[Search Items]
    User --> UC3[Filter by Category]
    User --> UC4[View Item Details]
    User --> UC5[Contact Seller]
    User --> UC6[Create Listing]
    User --> UC7[Edit Listing]
    User --> UC8[Delete Listing]
    User --> UC9[Feature Listing]
    User --> UC10[Manage Profile]
    
    UC1 --> System[CampusSwap System]
    UC2 --> System
    UC3 --> System
    UC4 --> System
    UC5 --> System
    UC6 --> System
    UC7 --> System
    UC8 --> System
    UC9 --> System
    UC10 --> System
```

### Detailed Use Case: Create Listing

```mermaid
sequenceDiagram
    participant U as User
    participant PV as ProfileView
    participant PVM as ProfileViewModel
    participant LS as ListingService
    participant FS as File System
    
    U->>PV: Tap "Create Listing"
    PV->>PV: Show CreateListingView
    U->>PV: Fill form (title, description, price, category)
    U->>PV: Tap "Save"
    PV->>PVM: createListing(listing)
    PVM->>LS: addListing(listing)
    LS->>LS: Add to listings array
    LS->>FS: Save to listings.json
    FS-->>LS: Success
    LS-->>PVM: Listing added
    PVM->>PVM: loadUserListings()
    PVM-->>PV: Update UI
    PV-->>U: Show new listing
```

---

## Class Diagrams

### Core Models

```mermaid
classDiagram
    class Listing {
        +UUID id
        +String title
        +String description
        +Double price
        +ItemCategory category
        +String sellerName
        +String sellerContact
        +Bool isFeatured
        +Date createdAt
        +String? imageName
    }
    
    class UserProfile {
        +String name
        +String contact
        +[UUID] listings
    }
    
    class ItemCategory {
        <<enumeration>>
        textbook
        furniture
        notes
    }
    
    Listing --> ItemCategory
    UserProfile --> Listing : references
```

### Service Layer

```mermaid
classDiagram
    class ListingService {
        -[Listing] listings
        -String fileName
        +shared: ListingService
        +loadListings()
        +saveListings()
        +addListing(Listing)
        +updateListing(Listing)
        +deleteListing(UUID)
        +getListing(UUID) Listing?
    }
    
    class UserService {
        -String userDefaultsKey
        +shared: UserService
        +getCurrentUser() UserProfile?
        +saveUser(UserProfile)
        +clearUser()
        +isCurrentUser(String) Bool
    }
    
    class FeaturedService {
        -String featuredIdsKey
        +shared: FeaturedService
        +isFeatured(UUID) Bool
        +setFeatured(UUID, Bool)
        +getFeaturedIds() [UUID]
    }
    
    ListingService --> Listing : manages
    UserService --> UserProfile : manages
    FeaturedService --> Listing : tracks featured status
```

### ViewModel Layer

```mermaid
classDiagram
    class FeedViewModel {
        +String searchText
        +ItemCategory? selectedCategory
        -ListingService listingService
        -FeaturedService featuredService
        +[Listing] listings
        +[Listing] filteredListings
        +refresh()
    }
    
    class ProfileViewModel {
        +[Listing] userListings
        -ListingService listingService
        -UserService userService
        +loadUserListings()
        +createListing(Listing)
        +updateListing(Listing)
        +deleteListing(IndexSet)
    }
    
    FeedViewModel --> ListingService : uses
    FeedViewModel --> FeaturedService : uses
    ProfileViewModel --> ListingService : uses
    ProfileViewModel --> UserService : uses
```

### View Layer

```mermaid
classDiagram
    class AppRootView {
        -Bool hasUserProfile
        +checkUserProfile()
    }
    
    class ProfileSetupView {
        -String name
        -String contact
        -Bool showingError
        +onComplete: () -> Void
        +saveProfile()
    }
    
    class ContentView {
        +body: some View
    }
    
    class FeedView {
        +body: some View
    }
    
    class ProfileView {
        +body: some View
    }
    
    AppRootView --> ProfileSetupView : shows if no profile
    AppRootView --> ContentView : shows if profile exists
    ContentView --> FeedView : contains
    ContentView --> ProfileView : contains
```

---

## Data Architecture

### Data Storage Strategy

#### UserDefaults
- **User Profile**: Current user's name, contact, and listing IDs
- **Featured Listing IDs**: Array of UUIDs for featured listings
- **Key**: `currentUser` (UserProfile JSON)
- **Key**: `featuredListingIds` ([UUID] JSON)

#### JSON File (listings.json)
- **Location**: App's Documents directory
- **Format**: JSON array of Listing objects
- **Encoding**: ISO8601 date format
- **Structure**:
```json
[
  {
    "id": "uuid",
    "title": "string",
    "description": "string",
    "price": 0.0,
    "category": "Textbook|Furniture|Notes",
    "sellerName": "string",
    "sellerContact": "string",
    "isFeatured": false,
    "createdAt": "2025-01-14T10:00:00Z",
    "imageName": "string?"
  }
]
```

### Data Model Relationships

```mermaid
erDiagram
    UserProfile ||--o{ Listing : "creates"
    Listing }o--|| ItemCategory : "has"
    FeaturedService ||--o{ Listing : "tracks"
    
    UserProfile {
        string name
        string contact
        array listingIds
    }
    
    Listing {
        uuid id
        string title
        string description
        double price
        string sellerName
        string sellerContact
        bool isFeatured
        date createdAt
    }
    
    ItemCategory {
        string textbook
        string furniture
        string notes
    }
```

---

## Component Architecture

### View Components Hierarchy

```
AppRootView
├── ProfileSetupView (if no profile)
└── ContentView (if profile exists)
    ├── TabView
    │   ├── FeedView
    │   │   ├── SearchBar
    │   │   ├── ListView / GridView
    │   │   └── ListingRow / ListingCard
    │   └── ProfileView
    │       ├── User Info
    │       └── Listings List
    └── NavigationStack
        └── ItemDetailView
            ├── Item Info
            ├── Contact Button
            └── Feature Button
```

### Service Layer Architecture

```
Services (Singleton Pattern)
├── ListingService
│   ├── CRUD Operations
│   ├── JSON Persistence
│   └── @Published listings
├── UserService
│   ├── Profile Management
│   └── UserDefaults Persistence
└── FeaturedService
    ├── Featured Status Tracking
    └── UserDefaults Persistence
```

---

## Navigation Architecture

### Navigation Flow

```mermaid
stateDiagram-v2
    [*] --> ProfileSetup: No Profile
    ProfileSetup --> MainApp: Profile Created
    [*] --> MainApp: Profile Exists
    
    state MainApp {
        [*] --> FeedTab
        [*] --> ProfileTab
        FeedTab --> ItemDetails: Tap Listing
        ItemDetails --> FeedTab: Back
        ProfileTab --> CreateListing: Create
        ProfileTab --> EditListing: Edit
        CreateListing --> ProfileTab: Save/Cancel
        EditListing --> ProfileTab: Save/Delete
    }
```

### Navigation Implementation

- **Tab Navigation**: `TabView` for main app sections
- **Stack Navigation**: `NavigationStack` for detail views
- **Modal Presentation**: `.sheet()` for forms and modals
- **Deep Linking**: Future enhancement for direct item links

---

## State Management

### Observable Pattern

```mermaid
flowchart TD
    A[@Published Property] --> B[View Observes]
    B --> C{Property Changes}
    C --> D[View Updates Automatically]
    
    E[User Action] --> F[ViewModel Method]
    F --> G[Update @Published]
    G --> A
```

### State Flow Example

```
User taps "Create Listing"
  ↓
ProfileView detects tap
  ↓
Shows CreateListingView (modal)
  ↓
User fills form and saves
  ↓
ProfileViewModel.createListing()
  ↓
ListingService.addListing()
  ↓
@Published listings updates
  ↓
ProfileViewModel.loadUserListings()
  ↓
@Published userListings updates
  ↓
ProfileView UI refreshes automatically
```

---

## Technical Stack

### Frameworks & Technologies

- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **iOS Version**: iOS 16.0+
- **Data Persistence**: 
  - UserDefaults (key-value storage)
  - FileManager (JSON file storage)
- **Architecture**: MVVM (Model-View-ViewModel)
- **State Management**: Combine framework (@Published, ObservableObject)
- **No External Dependencies**: Pure Apple frameworks only

### Design Patterns

1. **Singleton Pattern**: Services (ListingService, UserService, FeaturedService)
2. **Observer Pattern**: ViewModels observe Services via Combine
3. **Repository Pattern**: Services abstract data access
4. **MVVM Pattern**: Separation of concerns

---

## File Structure

### Current Implementation

```
CampusSwap/CampusSwap/
├── CampusSwapApp.swift          App entry point (AppRootView, WelcomeView integration)
├── Models/
│   ├── Listing.swift            Listing data model
│   ├── UserProfile.swift        User data model
│   └── ItemCategory.swift       Category enumeration
├── Views/
│   ├── Authentication/
│   │   ├── WelcomeView.swift    Entry screen (Login/Signup)
│   │   └── LoginView.swift      Mock login screen
│   ├── ProfileSetupView.swift   First-time user setup
│   ├── ContentView.swift        Main tab container
│   ├── FeedView.swift           Browse listings & Search
│   ├── ProfileView.swift        User profile & My Listings
│   ├── ItemDetailView.swift     Item details & Contact
│   ├── CreateListingView.swift  Create listing form
│   ├── EditListingView.swift    Edit listing form
│   ├── FeatureListingView.swift Feature purchase modal
│   └── Components/              (Various UI components)
├── ViewModels/
│   ├── FeedViewModel.swift      Feed logic & Filtering
│   ├── ProfileViewModel.swift   Profile logic & CRUD
│   └── ItemDetailViewModel.swift Item detail logic
├── Services/
│   ├── ListingService.swift     Listing CRUD operations
│   ├── UserService.swift        User profile & Auth management
│   ├── FeaturedService.swift    Featured listing tracking
│   └── SampleData.swift         Sample data generator
├── Utilities/
│   └── Extensions.swift         Helper extensions
└── Assets.xcassets/
    └── Logo.imageset/           App logo

Legend: Implemented
```

---

## Security & Privacy

### Data Privacy

- **Local Storage Only**: All data stored locally on device
- **No Backend**: No data transmitted to external servers
- **User Control**: Users can delete their profile and listings
- **Contact Information**: Only shared when user contacts seller

### Future Enhancements

- University email verification
- Secure authentication
- Encrypted local storage
- Privacy settings

---

## Performance Considerations

### Optimization Strategies

1. **Lazy Loading**: `LazyVStack` and `LazyVGrid` for large lists
2. **Efficient Filtering**: Computed properties for search/filter
3. **Singleton Services**: Shared instances reduce memory overhead
4. **JSON Caching**: Load once, update incrementally

### Scalability

- Current design supports 1000+ listings efficiently
- JSON file size manageable for local storage
- Future: Consider Core Data for larger datasets

---

## Testing Strategy

### Unit Testing (Future)

- Service layer tests
- ViewModel logic tests
- Data model validation tests

### Integration Testing (Future)

- End-to-end user flows
- Data persistence tests
- Navigation flow tests

---

## Future Enhancements

### Technical Improvements

1. **Core Data**: For more complex data relationships
2. **Image Storage**: Local image caching and management
3. **Offline Support**: Enhanced offline capabilities
4. **Push Notifications**: For new listings and messages
5. **Backend Integration**: Cloud sync and multi-device support

### Feature Additions

1. **Messaging System**: In-app communication
2. **Favorites/Wishlist**: Save items for later
3. **Ratings & Reviews**: Seller feedback system
4. **Map Integration**: Meetup location suggestions
5. **University Verification**: Email-based verification

---

**Document Version**: 1.0  
**Last Updated**: January 2026  
**Team**: CampusSwap Development Group
