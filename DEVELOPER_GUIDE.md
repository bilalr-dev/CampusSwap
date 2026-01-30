# CampusSwap Developer Guide

**Welcome to the CampusSwap Development Team!**
This document serves as the single source of truth for Project Structure, Architecture, Specifications, and our unique Git Workflow.

---

## 🏗️ 1. Project Structure & The "Golden Rule"

### The Golden Rule
**`main` is the SOURCE OF TRUTH.**
The `main` branch contains the fully integrated application, including the Data Layer, Authentication, and core features.

*   **Always** create your feature branches from `main`.
*   **Never** push directly to `main`. Use Pull Requests.
*   You MUST merge the **Data Layer** (Bilal's work, `feature/data-service`) to make the app functional.

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
Create a branch for your assigned feature from `main`:
```bash
# Example
git checkout main
git pull origin main
git checkout -b feature/your-feature-name
```

### Step 3: Verify Setup 🔍
1.  Open `CampusSwap.xcodeproj` in Xcode.
2.  Press `Cmd+R` to build and run the app.
3.  **Success**: You should see the **Welcome Screen** ("Log In" / "Sign Up").


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

1.  **Phase 1**: Bilal merges `feature/data-service` -> `main`. (Establishes the foundation).
2.  **Phase 2**: You pull the updated `main` into your feature branch: `git pull origin main`.
3.  **Phase 3**: You merge your feature branch -> `main`.

---

## 🚫 Do's and Don'ts

*   **DO** commit often.
*   **DO** pull `origin/feature/data-service` if Bilal updates models.
*   **DON'T** rename files (the scaffold relies on fixed names).
*   **DON'T** edit `CampusSwap.xcodeproj` settings unless necessary.
