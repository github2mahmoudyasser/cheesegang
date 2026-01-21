# 🚀 Project Commands Reference

## 🛠 Flutter & Hive (The Standards)
# Generate Hive Adapters and JSON Models (Your Favorite Command):
flutter pub run build_runner build --delete-conflicting-outputs

# Clean project and repair dependencies:
flutter clean && flutter pub get

---

## 🌿 Git Branching & Workflow
# Create a new branch and switch to it immediately:
git checkout -b feature-name

# Switch between existing branches:
git checkout branch-name

# Rename the current local branch:
git branch -m new-branch-name

# List all local branches:
git branch

---

## 🚨 Emergency & Undo (The "Save Me" Commands)
# Hard reset: Delete all local changes and sync with the server (Origin):
git reset --hard origin/branch-name

# Discard all local changes (Uncommitted) and go back to last commit:
git reset --hard HEAD

# Undo the last commit but keep the code changes in your editor:
git reset --soft HEAD~1

---

## 📤 Push & Pull (Remote Sync)
# Push a new branch to the server for the first time:
git push -u origin branch-name

# Update your current branch with the latest code from Main:
git pull origin main

---

## 🧹 Maintenance
# Delete a local branch (only after merging it):
git branch -d branch-name

# Force delete a branch (Even if not merged):
git branch -D branch-name