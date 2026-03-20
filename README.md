# FogMap

<p align="center">
  <img src="https://img.shields.io/badge/iOS-SwiftUI-blue">
  <img src="https://img.shields.io/badge/Maps-MapKit-black">
  <img src="https://img.shields.io/badge/Backend-Firebase-orange">
  <img src="https://img.shields.io/badge/License-MIT-green">
</p>

<p align="center">
  <img width="300" src="https://github.com/user-attachments/assets/7d80e28e-f869-4572-be66-1dd27509f8a7" />
  <img width="300" src="https://github.com/user-attachments/assets/1d41d73a-14e8-4d1b-896d-0436b9723e40" />
</p>


FogMap is a location based exploration app built with SwiftUI.

It transforms real world movement into a game by letting you unlock the map as you explore.

No scrolling. No lists.
Just you and the world.

#### Concept:

FogMap introduces a simple idea.

<p align="center">
  <b>Move → Reveal → Discover</b>
</p>

The map starts covered in fog.
As you travel, the fog disappears and reveals the world you’ve explored.

## Why FogMap?

Traditional map apps show everything.

FogMap flips that idea:
```You only see what you’ve explored.```

This creates:
- A sense of progress
- A personal journey
- A game-like exploration experience

## Core Mechanics

<p align="center">
  <b>Move → Reveal Map</b>
  <br>
  <b>Visit → Unlock Countries</b>
</p>

- Walk, travel, or explore anywhere
- Your path reveals the map in real time
- Countries get added to your personal passport

## Architecture

| Stack                         | What it does?             |
| ----------------------------- | ------------------------- |
| `SwiftUI`                     | UI and state management   |
| `MapKit`                      | map rendering             |
| `Firebase Auth`               | authentication            |
| `Firestore`                   | user data                 |
| `CloudKit`                    | iCloud backup             |
| `CoreLocation`                | tracking                  |
| `Custom Polygon Engine (WIP)` | offline country detection |

## Features

1. Real-time map exploration (MapKit)
2. Dynamic fog system
3. Location tracking & reveal radius
4. Automatic country detection (CLGeocoder → Polygon fallback)
5. Passport system (visited countries)
6. iCloud backup (I need to activate my Apple Developer Account for CloudKit)
7. Firebase Authentication (Email / Google / Apple)
8. Exploration stats (countries + progress)
9. Light / Dark theme support
10. Smooth SwiftUI animations

## Requirements

To run **FogMap** locally, you will need:

#### Development Environment

- macOS (latest stable version recommended)
- Xcode 15+
- iOS 17+ Simulator or physical device
- Swift 5.9+

## Installation

1. Clone the repository:
   
```bash
git clone https://github.com/Osman-Kahraman/FogMap.git
```

3. Open in Xcode
4. Configure your Google Firebase credentials
5. Run on simulator

## Setup

### 1. Firebase

- Create a Firebase project
- Enable Authentication (Email + Google)
- Enable Firestore
- Add GoogleService-Info.plist to the project

### 2. Google Sign-In

- Add URL scheme from Firebase config
- Enable provider in Firebase console

### 3. iCloud (Optional)

- Enable CloudKit capability in Xcode

⚠️ **IMPORTANT: It requires Apple Developer account**

## Documentation

For detailed documentation, architecture explanations, and development setup, please visit the project Wiki.

<p align="center">
  <a href="https://github.com/Osman-Kahraman/FogMap/wiki">
    View the FogMap Wiki
  </a>
</p>

The Wiki includes:

- Installation guide
- OAuth authentication flow
- Project architecture
- GitHub API usage
- Configuration details
- Contribution guidelines

## Licence

This tool is under the [MIT License](LICENSE.md)

<p align="center">
  <b>Official iOS app coming soon on the App Store.</b>
</p>