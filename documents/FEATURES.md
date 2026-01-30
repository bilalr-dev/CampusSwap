# CampusSwap - Feature Specification

## Overview

This document defines all features and functionality for the CampusSwap iOS application. Each feature includes user stories, acceptance criteria, UI/UX requirements, and technical considerations.

**App Name**: CampusSwap  
**Target Users**: EPITA and nearby university students  
**Monetization**: Freemium (featured listings €2-5) + Advertising

---

## Feature 1: Browse Listings (Main Feed)

### Description
The main feed screen displays all available listings in a scrollable list or grid view. Users can browse items, see featured listings at the top, and navigate to item details.

### User Stories
- **As a buyer**, I want to browse all available items so I can find what I'm looking for
- **As a buyer**, I want to see featured items first so I can discover popular or premium listings
- **As a user**, I want to toggle between list and grid views so I can choose my preferred browsing style
- **As a buyer**, I want to see item previews (title, price, category) so I can quickly scan available items

### Acceptance Criteria
- . All listings are displayed in chronological order (newest first)
- . Featured listings appear at the top of the feed with a badge
- . Users can toggle between list view and grid view
- . Each listing shows: title, price, category, featured badge (if applicable)
- . Tapping a listing navigates to Item Details screen
- . Feed is scrollable and loads all available listings
- . Empty state shown when no listings exist
- . Pull-to-refresh functionality updates the feed

### UI Components

**List View**:
- Vertical scrolling list
- Each row shows:
  - Featured badge (if applicable) - gold/star icon
  - Item image placeholder or icon
  - Title (bold, 16pt)
  - Category badge (Textbook/Furniture/Notes)
  - Price (prominent, 18pt, bold)
  - Seller name (smaller, gray text)
- Row height: ~100pt

**Grid View**:
- 2-column grid layout
- Each card shows:
  - Featured badge overlay (top-right corner)
  - Item image placeholder
  - Title (truncated if long)
  - Price (prominent)
  - Category icon/badge
- Card size: ~160x200pt

**View Toggle**:
- Button in navigation bar (list/grid icon)
- Toggles between views instantly
- Preference saved in UserDefaults

### Technical Requirements
- View: `FeedView.swift`
- ViewModel: `FeedViewModel` (observable object)
- Service: Uses `ListingService` to load listings
- Sorting: Featured first, then by date (newest first)
- Performance: Efficient rendering for 50+ listings

---

## Feature 2: Create Listing

### Description
Users can create new listings by filling out a form with item details. The listing is saved and appears in the feed.

### User Stories
- **As a seller**, I want to create a listing so I can sell my items
- **As a seller**, I want to add item details (title, description, price, category) so buyers know what I'm selling
- **As a seller**, I want to add my contact information so buyers can reach me
- **As a seller**, I want to see validation errors so I can fix my input before submitting

### Acceptance Criteria
- . Form includes: Title, Description, Price, Category, Contact Info
- . Title is required (minimum 3 characters, maximum 100)
- . Description is optional but recommended (maximum 500 characters)
- . Price is required (must be positive number)
- . Category selection (Textbook, Furniture, Notes)
- . Contact info is required (email or phone)
- . Form validation shows errors before submission
- . Success message shown after listing is created
- . New listing appears in feed immediately
- . User is returned to Profile screen after creation

### UI Components

**Form Fields**:
- **Title**: TextField with placeholder "Enter item title"
- **Description**: TextEditor (multiline) with placeholder "Describe your item..."
- **Price**: TextField with number pad, currency formatting (€)
- **Category**: Picker with options (Textbook, Furniture, Notes)
- **Contact**: TextField with placeholder "Email or phone number"

**Validation**:
- Real-time validation feedback
- Error messages below each field
- Submit button disabled until all required fields valid

**Actions**:
- "Cancel" button (dismisses form)
- "Create Listing" button (saves and creates)

### Technical Requirements
- View: `CreateListingView.swift`
- ViewModel: `ProfileViewModel` handles creation
- Service: `ListingService.addListing()`
- Validation: Client-side validation before submission
- Data: Creates new `Listing` object with UUID, current date

---

## Feature 3: Item Details

### Description
Displays complete information about a selected listing, including seller contact information and option to feature the listing.

### User Stories
- **As a buyer**, I want to see full item details so I can decide if I want to buy
- **As a buyer**, I want to contact the seller so I can arrange purchase
- **As a seller**, I want to feature my listing so it gets more visibility
- **As a user**, I want to see if a listing is featured so I know it's a premium listing

### Acceptance Criteria
- . Displays all item information: title, description, price, category, seller info
- . Shows featured badge if listing is featured
- . "Contact Seller" button displays seller contact info
- . "Feature This Listing" button shown if listing is not featured
- . Contact info shown in alert/action sheet (not always visible for privacy)
- . Navigation back to feed works correctly
- . If user owns the listing, shows "Edit" option instead of "Contact Seller"

### UI Components

**Header**:
- Featured badge (if applicable)
- Item image placeholder
- Category badge

**Details Section**:
- Title (large, bold)
- Price (prominent, 24pt)
- Description (scrollable text)
- Seller name
- Posted date

**Actions**:
- "Contact Seller" button (primary action)
  - Shows alert with contact info
  - Options: "Copy Contact", "OK"
- "Feature This Listing" button (if not featured)
  - Opens Feature Listing modal
- "Edit" button (if user owns listing)
  - Navigates to Edit Listing screen

### Technical Requirements
- View: `ItemDetailView.swift`
- ViewModel: `ItemDetailViewModel`
- Service: Uses `ListingService` to fetch listing by ID
- Contact: Uses `UserService` to check if current user owns listing
- Navigation: Uses NavigationLink from FeedView

---

## Feature 4: User Profile / My Listings

### Description
Users can view and manage their own listings, create new listings, and edit or delete existing ones.

### User Stories
- **As a seller**, I want to see all my listings in one place so I can manage them
- **As a seller**, I want to edit my listings so I can update prices or descriptions
- **As a seller**, I want to delete listings so I can remove sold or unwanted items
- **As a seller**, I want to create new listings quickly so I can sell more items

### Acceptance Criteria
- . Displays user's profile information (name, contact)
- . Shows list of user's listings
- . Each listing shows: title, price, category, featured status
- . "Create New Listing" button opens creation form
- . Tapping a listing navigates to Edit screen
- . Swipe-to-delete or delete button removes listing
- . Confirmation dialog before deletion
- . Empty state shown when user has no listings
- . Listings sorted by date (newest first)

### UI Components

**Profile Header**:
- User name
- Contact information
- Total listings count

**Listings Section**:
- List of user's listings
- Each row shows:
  - Title
  - Price
  - Category badge
  - Featured badge (if applicable)
  - Posted date
- Swipe actions: Delete

**Actions**:
- "Create New Listing" button (floating action button or top button)
- Edit: Tap listing to edit
- Delete: Swipe left or delete button

### Technical Requirements
- View: `ProfileView.swift`
- ViewModel: `ProfileViewModel`
- Service: `ListingService` filters by seller
- User: `UserService` provides current user info
- Edit: `EditListingView.swift` for editing
- Delete: Confirmation dialog, then `ListingService.deleteListing()`

---

## Feature 5: Search & Filter

### Description
Users can search listings by keywords and filter by category and price range to find specific items.

### User Stories
- **As a buyer**, I want to search for specific items so I can find what I need quickly
- **As a buyer**, I want to filter by category so I can browse only textbooks or furniture
- **As a buyer**, I want to filter by price range so I can find items within my budget
- **As a user**, I want to clear filters easily so I can see all listings again

### Acceptance Criteria
- . Search bar at top of feed
- . Real-time search as user types (debounced)
- . Search matches title and description
- . Filter by category (All, Textbook, Furniture, Notes)
- . Filter by price range (slider or min/max inputs)
- . Active filters shown as badges/chips
- . "Clear Filters" button resets all filters
- . Search and filters work together (combined)
- . Results update immediately

### UI Components

**Search Bar**:
- TextField with search icon
- Placeholder: "Search listings..."
- Clear button when text entered
- Real-time filtering

**Filter Section**:
- Category filter: Segmented control or picker
  - Options: All, Textbook, Furniture, Notes
- Price filter: Range slider or two TextFields
  - Min price, Max price
  - "Apply" button

**Filter Indicators**:
- Active filters shown as chips/badges
- "Clear All" button when filters active

### Technical Requirements
- View: Integrated into `FeedView`
- ViewModel: `FeedViewModel` handles search/filter logic
- Search: Case-insensitive, matches title and description
- Filter: Combines category and price filters
- Performance: Efficient filtering for large lists

---

## Feature 6: Featured Listings

### Description
Sellers can pay to feature their listings, making them appear at the top of the feed with a special badge for increased visibility.

### User Stories
- **As a seller**, I want to feature my listing so it gets more visibility
- **As a seller**, I want to see the benefits of featuring before paying
- **As a buyer**, I want to see featured items first so I can discover premium listings
- **As a seller**, I want the feature purchase to be quick and simple

### Acceptance Criteria
- . Featured listings appear at top of feed
- . Featured badge displayed on featured items
- . "Feature This Listing" button on Item Details (if not featured)
- . Feature purchase modal shows pricing and benefits
- . Mock purchase flow (no real payment processing)
- . After "purchase", listing is marked as featured
- . Featured status persists across app sessions
- . Featured listings sorted by date among featured items

### UI Components

**Featured Badge**:
- Gold/yellow badge with star icon
- Text: "FEATURED"
- Position: Top-right corner of listing card/row
- Distinctive styling (different from category badges)

**Feature Listing Modal** (`FeatureListingView.swift`):
- Title: "Feature Your Listing"
- Pricing: "€3.00" (or configurable)
- Benefits list:
  - Appears at top of feed
  - Featured badge for visibility
  - Priority in search results
- "Purchase" button (primary)
- "Cancel" button
- Loading state during mock purchase
- Success message after purchase

**Purchase Flow**:
1. User taps "Feature This Listing"
2. Modal appears with pricing
3. User taps "Purchase"
4. Loading indicator shown
5. After 1-2 seconds, success message
6. Listing marked as featured
7. Modal dismisses
8. Feed refreshes to show featured item at top

### Technical Requirements
- View: `FeatureListingView.swift` (modal)
- Service: `FeaturedService` manages featured status
- Storage: Featured listing IDs stored in UserDefaults
- Sorting: `FeedViewModel` sorts featured items first
- Mock: No real payment processing, just UI flow

---

## Feature 7: Ad Placements

### Description
Non-intrusive banner ads for local student-friendly businesses appear periodically in the feed.

### User Stories
- **As a user**, I want ads to be non-intrusive so they don't interrupt my browsing
- **As a business**, I want to advertise to students so I can reach my target audience
- **As a user**, I want ads to be relevant so they're actually useful

### Acceptance Criteria
- . Ad banners appear every 5-10 listings in feed
- . Ads are clearly marked as "Ad" or "Sponsored"
- . Ads don't interfere with listing browsing
- . Ads are relevant to students (cafes, print shops, etc.)
- . Ads are non-clickable in MVP (just visual)
- . Ad content is mock/placeholder for demo

### UI Components

**Ad Banner**:
- Rectangular banner (~320x50pt)
- Background color (distinct from listings)
- Text: "Ad: [Business Name] - [Message]"
- Example: "Ad: Campus Cafe - 10% student discount"
- Small "Ad" label in corner
- Styling: Clearly different from listings

**Placement**:
- Between listings (not at very top)
- Every 5-10 items
- Consistent spacing

### Technical Requirements
- Component: `AdBannerView.swift`
- Data: Mock ad data structure
- Integration: Added to `FeedView` at intervals
- Future: Can be replaced with real ad SDK

---

## Feature Interactions & User Flows

### Flow 1: Browse and Buy
1. User opens app → Feed screen
2. User browses listings (list/grid view)
3. User searches/filters if needed
4. User taps listing → Item Details
5. User taps "Contact Seller" → Sees contact info
6. User contacts seller outside app

### Flow 2: Create and Sell
1. User taps Profile tab → Profile screen
2. User taps "Create New Listing"
3. User fills form → Creates listing
4. User returns to Profile → Sees new listing
5. User taps listing → Can edit or feature

### Flow 3: Feature a Listing
1. User views Item Details (own listing)
2. User taps "Feature This Listing"
3. Modal shows pricing and benefits
4. User taps "Purchase"
5. Mock purchase completes
6. Listing becomes featured
7. User sees featured badge

### Flow 4: Edit/Delete Listing
1. User goes to Profile screen
2. User sees their listings
3. User taps listing → Edit screen
4. User modifies details → Saves
5. OR: User swipes to delete → Confirms → Deleted

---

## Technical Architecture Summary

### Views
- `FeedView.swift` - Main feed with listings
- `ItemDetailView.swift` - Item details
- `ProfileView.swift` - User profile and listings
- `CreateListingView.swift` - Create new listing
- `EditListingView.swift` - Edit existing listing
- `FeatureListingView.swift` - Feature purchase modal

### ViewModels
- `FeedViewModel` - Manages feed state, search, filters
- `ItemDetailViewModel` - Manages item details
- `ProfileViewModel` - Manages user listings, create/edit

### Services
- `ListingService` - CRUD operations for listings
- `UserService` - User profile management
- `FeaturedService` - Featured listing management

### Models
- `Listing` - Listing data structure
- `UserProfile` - User data structure
- `ItemCategory` - Category enum

---

## Priority & Implementation Order

### Phase 1 (Core Features - Must Have)
1. Browse Listings (Feed)
2. Create Listing
3. Item Details
4. User Profile / My Listings

### Phase 2 (Enhancement Features)
5. Search & Filter
6. Featured Listings

### Phase 3 (Monetization)
7. Ad Placements

---

## Future Enhancements (Out of Scope for MVP)

- User authentication (university email verification)
- Image uploads (currently placeholders)
- Messaging system within app
- Favorites/Wishlist
- Notifications
- Ratings and reviews
- Map integration for meetup locations
- Payment processing (real featured listing purchases)

---

**Document Version**: 1.0  
**Last Updated**: January 2026  
**Team**: CampusSwap Development Group
