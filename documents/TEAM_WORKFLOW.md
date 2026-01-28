# Team Development Workflow

## 1. Getting Started for All Developers

**Repository URL**: `https://github.com/bilalr-dev/CampusSwap.git`

The `main` branch currently contains the **Project Scaffold** (empty folders and stubbed files).
The `feature/bilal-work` branch contains the **Data Layer** (Models and Services).

### Step 1: Clone the Repository
Open your terminal and run:
```bash
git clone https://github.com/bilalr-dev/CampusSwap.git
cd CampusSwap
```

### Step 2: Create Your Feature Branch
Create a new branch for your specific feature (based on `main`):

**For Aakash (Feed):**
```bash
git checkout -b feature/feed-screen
```

**For Mouhamad (Profile/Details):**
```bash
git checkout -b feature/profile-screen
```

**For Helijao (Premium/UI):**
```bash
git checkout -b feature/premium-features
```

## 2. Critical Step: Integrating Core Logic
Since `main` only has empty files, you cannot build your UI (e.g., access `Listing.title` or `UserService.shared`) without the core logic.

**You MUST merge Bilal's work into your branch to get the Models and Services:**

```bash
git fetch origin
git merge origin/feature/bilal-work
```

*Resolve any conflicts if they occur (unlikely at start).*

## 3. Daily Workflow

1.  **Work on your feature**: Edit Views and ViewModels in your assigned folders.
2.  **Commit often**:
    ```bash
    git add .
    git commit -m "Implement listing row view"
    ```
3.  **Push your branch**:
    ```bash
    git push -u origin feature/your-branch-name
    ```
4.  **Open Pull Request**: When ready, open a PR to merge into `main`.

## 4. Integration & Merging Strategy (End Game)

We will merge branches into `main` in a specific order to minimize conflicts. This should happen when features are complete (e.g., Jan 30th/31st).

### Step 1: Merge Base Layer (Bilal)
Bilal merges `feature/bilal-work` into `main` first. This establishes the Models and Services as the source of truth on the main branch.

### Step 2: Merge Core Features (Aakash & Mouhamad)
Once the base layer is in `main`:
1.  **Pull `main` into your feature branch** to ensure compatibility.
2.  Resolve any final conflicts.
3.  Merge your feature branch into `main`.

### Step 3: Merge UI Polish (Helijao)
Helijao merges last to apply styling and premium touches on top of the completed features.
