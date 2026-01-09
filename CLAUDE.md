# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AtlasPowerliftingApp is a native iOS application built with SwiftUI and SwiftData for powerlifting tracking and management.

## Project Structure

This is a standard Xcode-based iOS project with the following key components:

- **AtlasPowerliftingApp/**: Main application source code
  - `AtlasPowerliftingAppApp.swift`: App entry point with SwiftData ModelContainer configuration
  - `ContentView.swift`: Primary view with navigation and data display
  - `Item.swift`: SwiftData model definitions
  - `Assets.xcassets/`: App assets, icons, and colors

- **AtlasPowerliftingAppTests/**: Unit tests using Swift Testing framework
- **AtlasPowerliftingAppUITests/**: UI tests using XCTest framework

## Development Commands

This project uses Xcode and xcodebuild for building and testing. All commands should be run from the repository root.

### Building

```bash
# Build the app
xcodebuild -project AtlasPowerliftingApp.xcodeproj -scheme AtlasPowerliftingApp -configuration Debug

# Build for release
xcodebuild -project AtlasPowerliftingApp.xcodeproj -scheme AtlasPowerliftingApp -configuration Release
```

### Testing

```bash
# Run all unit tests
xcodebuild test -project AtlasPowerliftingApp.xcodeproj -scheme AtlasPowerliftingApp -destination 'platform=iOS Simulator,name=iPhone 15'

# Run only unit tests (not UI tests)
xcodebuild test -project AtlasPowerliftingApp.xcodeproj -scheme AtlasPowerliftingApp -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:AtlasPowerliftingAppTests

# Run only UI tests
xcodebuild test -project AtlasPowerliftingApp.xcodeproj -scheme AtlasPowerliftingApp -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:AtlasPowerliftingAppUITests

# Run a specific test
xcodebuild test -project AtlasPowerliftingApp.xcodeproj -scheme AtlasPowerliftingApp -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:AtlasPowerliftingAppTests/AtlasPowerliftingAppTests/example
```

Note: You can list available simulators with: `xcrun simctl list devices`

### Cleaning

```bash
# Clean build artifacts
xcodebuild clean -project AtlasPowerliftingApp.xcodeproj -scheme AtlasPowerliftingApp
```

## Architecture

### Data Layer

The app uses **SwiftData** for data persistence:

- Models are defined using the `@Model` macro (see `Item.swift`)
- The ModelContainer is configured in the app entry point with a Schema containing all model types
- The shared ModelContainer is injected into the view hierarchy via `.modelContainer()` modifier
- Views access data using `@Query` property wrapper and modify data through `@Environment(\.modelContext)`

### UI Layer

The app uses **SwiftUI** with the following patterns:

- `NavigationSplitView` provides the main navigation structure (list/detail)
- `@Query` automatically updates views when underlying SwiftData models change
- Model operations (insert, delete) are performed through the `modelContext`
- Preview macros (`#Preview`) are used for SwiftUI previews with in-memory model containers

### Testing

- **Unit tests**: Use Swift Testing framework (`import Testing`, `@Test` attribute)
- **UI tests**: Use XCTest framework with XCUIApplication for app interaction
