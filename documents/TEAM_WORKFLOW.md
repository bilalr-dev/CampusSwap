# Team Development Workflow

**Reference Reference**: See `DEVELOPER_GUIDE.md` in the root directory for the most up-to-date instructions.

## Quick Start Checklist

1.  **Clone**: `git clone https://github.com/bilalrahaoui/CampusSwap.git`
2.  **Pull**: `git checkout main && git pull`
3.  **Branch**: `git checkout -b feature/your-feature-name`
4.  **Verify**: Build the app (Cmd+R) to ensure it runs green.

## Branching Strategy

*   `main`: **Production Ready**. Contains all verifiable features and the Core Data Layer.
*   `feature/*`: Your working branches. Merge back to `main` via Pull Request (PR).

## Merging back to Main (End Game)

1.  Push your feature branch: `git push origin feature/your-feature-name`
2.  Open a Pull Request (PR) on GitHub.
3.  Request review from Bilal or another lead.
4.  Once approved, merge into `main`.
