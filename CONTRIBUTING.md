# Contributing to FogMap

Thank you for your interest in contributing to FogMap! Contributions are welcome, whether it is a bug fix, an improvement, or a new idea. If you have a suggestion, feel free to open an issue or submit a pull request.

## Getting Started

1. Fork the repository
2. Clone your fork

```bash
git clone https://github.com/Osman-Kahraman/FogMap.git
cd FogMap
```

3. Create a new branch for your change

```bash
git checkout -b feature/YOUR-FEATURE-NAME
```

4. Make your changes and commit them

```bash
git commit -m "Add: short description"
```

5. Push your branch

```bash
git push origin feature/your-feature-name
```

6. Open a Pull Request

## Development Setup

These steps cover the minimum setup required to run the app locally.

### 1. Firebase setup

Create a project in the Firebase Console and download `GoogleService-Info.plist`.

- Add an **iOS app** in Firebase and register your **Bundle ID** (case-sensitive)
- Add `GoogleService-Info.plist` to the **root** of the Xcode project
- Make sure the file is added to **all targets**
- Enable Firebase Authentication providers (Email/Password, Google, Apple if needed)
- Enable Firestore

### 2. Google Sign-In (Firebase Auth)

- Enable the Google provider in Firebase Authentication
- Copy `REVERSED_CLIENT_ID` from `GoogleService-Info.plist`
- In Xcode, go to **Target → Info → URL Types** and add it as a URL scheme

### 3. iCloud (Optional)

- Enable the CloudKit capability in Xcode

> Note: CloudKit requires an Apple Developer account.

## Requirements

- macOS (latest stable recommended)
- Xcode 15+
- iOS 17+ (Simulator or device)
- Swift 5.9+

## Contribution Guidelines

- Keep PRs small and focused
- Follow existing SwiftUI code style and architecture
- Link changes to an issue when possible
- Verify the app runs before submitting a PR
- Do not commit secrets or config files such as `GoogleService-Info.plist`

Example commit messages:

```sh
Fix: fog reveal radius calc
Add: passport empty state
Refactor: LocationManager cleanup
```

## Code of Conduct

All contributors are expected to follow the rules in `CODE_OF_CONDUCT.md`.

---

Thanks for helping make **FogMap** better.
