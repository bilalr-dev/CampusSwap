# Team Development Workflow

**Reference Reference**: See `DEVELOPER_GUIDE.md` in the root directory for the most up-to-date instructions.

## Quick Start Checklist

1.  **Clone**: `git clone https://github.com/bilalr-dev/CampusSwap.git`
2.  **Branch**: `git checkout -b feature/your-feature-name`
3.  **Integrate Core**: `git merge origin/feature/data-service` (Crucial!)
4.  **Verify**: Check that `Listing.swift` is not empty.

## Branching Strategy

*   `main`: **Scaffold** (Stubs only). Do not push here directly.
*   `feature/data-service`: **Data Layer Source** (was `feature/bilal-work`).
*   `feature/*`: Your working branches.

## Merging back to Main (End Game)

1.  Bilal merges `feature/data-service` into `main`.
2.  Feature Leads (Aakash, Mouhamad, Helijao) pull `main` to get the latest code.
3.  Feature Leads merge their finished features into `main`.
