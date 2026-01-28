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
*Auto-merge should work seamlessly as you are merging code into empty stubs.*

---

## 🏛️ 3. Technical Architecture

### Pattern: MVVM (Model-View-ViewModel)
*   **Models**: Pure data structs (`Listing`, `UserProfile`). Codable.
*   **Services**: Singletons handling data persistence (`UserService`, `ListingService`).
*   **ViewModels**: `ObservableObject` classes that hold state for Views.
*   **Views**: SwiftUI views that observe ViewModels.

### Data Flow
1.  **Views** read data from **ViewModels**.
2.  **ViewModels** fetch/save data via **Services**.
3.  **Services** persist data to `listings.json` or `UserDefaults`.

---

## 📋 4. Developer Specifications & ownership

To avoid conflicts, stick to your assigned files.

### 👨‍💻 Bilal (Data Layer)
*   **Files**: `Models/*`, `Services/*`
*   **Responsibility**: Core logic, persistence, `AppRootView` logic.

### 👨‍💻 Aakash (Feed & Discovery)
*   **Files**: 
    *   `Views/FeedView.swift`
    *   `Views/FeaturedListingView.swift` (shared)
    *   `ViewModels/FeedViewModel.swift`
*   **Responsibility**: Main feed UI, Search bar, Filtering logic, Grid/List toggle.

### 👨‍💻 Mouhamad (Profile & Items)
*   **Files**: 
    *   `Views/ProfileSetupView.swift`
    *   `Views/ProfileView.swift`
    *   `Views/ItemDetailView.swift`
    *   `Views/CreateListingView.swift`
    *   `ViewModels/ProfileViewModel.swift`
    *   `ViewModels/ItemDetailViewModel.swift`
*   **Responsibility**: User onboarding, Item details screen, Profile management, "My Listings".

### 👨‍💻 Helijao (Premium & Polish)
*   **Files**: 
    *   `Views/FeaturedListingView.swift` (Premium logic)
    *   Global UI styling (`Utilities/Extensions.swift`)
*   **Responsibility**: Premium purchase flow, Ads, UI Polish, Animations, Empty States.

---

## 🤝 5. Merging Strategy (The End Game)

**DO NOT MERGE INTO MAIN UNTIL APPROVED.**

Our integration order is strict:

1.  **Phase 1**: Bilal merges `feature/bilal-work` -> `main`. (Establishes the foundation).
2.  **Phase 2**: You pull the updated `main` into your feature branch:
    ```bash
    git pull origin main
    ```
    (This ensures compatibility).
3.  **Phase 3**: You merge your feature branch -> `main`.

---

## 🆘 Troubleshooting

**"I have compilation errors about missing types!"**
-> You likely forgot Step 3 (Merge Bilal's work). Run `git merge origin/feature/bilal-work`.

**"I have merge conflicts!"**
-> Contact Bilal or the team lead immediately. Do not force push.

Happy Coding! 🚀
