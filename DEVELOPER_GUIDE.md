# CampusSwap Developer Guide

**Welcome to the CampusSwap Development Team!**
This document serves as the single source of truth for Project Structure, Architecture, Specifications, and our unique Git Workflow.

---

## 🏗️ 1. Project Structure & The "Golden Rule"

### The Golden Rule
**`main` is a SCAFFOLD.**
The `main` branch contains the full folder structure and all Swift files, but **the implementation code is missing (stubbed)**.

*   You CANNOT build the app from `main` alone.
*   You MUST merge the **Data Layer** (Bilal's work) to make the app functional.

### Why?
This ensures we all start with identical file paths and class names (avoiding merge conflicts on file creation) while allowing the Data Layer to be built independently.

### Directory Structure
```
CampusSwap/
├── Models/           (Bilal)
├── Services/         (Bilal)
├── ViewModels/       (Aakash, Mouhamad, Helijao)
├── Views/            (Aakash, Mouhamad, Helijao)
├── Utilities/        (Shared)
└── CampusSwapApp.swift
```

---

## 🚀 2. Getting Started (Git Workflow)

Follow this EXACT sequence to set up your environment:

### Step 1: Clone the Repo
```bash
git clone https://github.com/bilalr-dev/CampusSwap.git
cd CampusSwap
```

### Step 2: Create Your Feature Branch
Create a branch for your assigned feature:
```bash
# Aakash
git checkout -b feature/feed-screen

# Mouhamad
git checkout -b feature/profile-screen

# Helijao
git checkout -b feature/premium-features
```

### Step 3: ⚠️ INTEGRATE THE DATA LAYER ⚠️
This is the most important step. You need Bilal's Models and Services to work.
```bash
git fetch origin
git merge origin/feature/bilal-work
```

### Step 4: Verify Setup 🔍
1.  Open `CampusSwap.xcodeproj` in Xcode.
2.  Open `Models/Listing.swift`.
3.  **Correct**: You see `struct Listing: Identifiable, Codable ...` with full properties.
4.  **Incorrect**: You see `// TODO: Implement Listing` or just `struct Listing {}`.
    *   *Fix*: Run the merge command in Step 3 again.

---

## 🏛️ 3. Technical Architecture

### Pattern: MVVM (Model-View-ViewModel)
*   **Models**: Pure data structs (`Listing`, `UserProfile`). Codable.
*   **Services**: Singletons handling data persistence (`UserService`, `ListingService`).
*   **ViewModels**: `ObservableObject` classes that hold state for Views.
*   **Views**: SwiftUI views that observe ViewModels.

---

## 📋 4. Developer Specifications & Ownership

To avoid conflicts, **ONLY EDIT FILES YOU OWN**.

### 👨‍💻 Bilal (Data Layer)
*   **Owning**: `Models/*`, `Services/*`, `CampusSwapApp.swift` (Root Logic).
*   **Responsibility**: Core infrastructure, data persistence.

### 👨‍💻 Aakash (Feed & Discovery)
*   **Owning**: `ViewModels/FeedViewModel.swift`, `Views/FeedView.swift`.
*   **Shared**: `Views/FeaturedListingView.swift`.
*   **Responsibility**: Search, Filters, Grid/List Toggle.

### 👨‍💻 Mouhamad (Profile & Items)
*   **Owning**: `ViewModels/ProfileViewModel.swift`, `ViewModels/ItemDetailViewModel.swift`, `Views/Profile*.swift`, `Views/ItemDetailView.swift`, `Views/CreateListingView.swift`.
*   **Responsibility**: Authentication flows, CRUD operations, User Profile.

### 👨‍💻 Helijao (Premium & Polish)
*   **Owning**: `Utilities/Extensions.swift`, `Views/FeaturedListingView.swift` (Premium logic).
*   **Responsibility**: UI Styling, Animations, Premium purchase flow.

---

## 🤝 5. Merging Strategy (The End Game)

**DO NOT MERGE INTO MAIN UNTIL APPROVED.**

1.  **Phase 1**: Bilal merges `feature/bilal-work` -> `main`. (Establishes the foundation).
2.  **Phase 2**: You pull the updated `main` into your feature branch: `git pull origin main`.
3.  **Phase 3**: You merge your feature branch -> `main`.

---

## 🚫 Do's and Don'ts

*   **DO** commit often.
*   **DO** pull `origin/feature/bilal-work` if Bilal updates models.
*   **DON'T** rename files (the scaffold relies on fixed names).
*   **DON'T** edit `CampusSwap.xcodeproj` settings unless necessary.
