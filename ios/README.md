# iOS Sample App - Dyad

This directory contains a sample iOS application built with Swift and SwiftUI, demonstrating the capabilities of the Dyad iOS app builder.

## Overview

The DyadSampleApp is a minimal iOS application that showcases:
- **SwiftUI-based user interface** with modern iOS design patterns
- **Networking capability** to fetch data from a REST API
- **Unit tests** for core functionality
- **Swift Package Manager** support for dependencies

## Features

- 📱 Native iOS app with SwiftUI
- 🌐 Network requests using URLSession
- 🧪 Unit tests with XCTest
- 🎨 Modern UI with SF Symbols
- 📦 Clean architecture with separation of concerns

## Requirements

To build and run this app, you need:
- **macOS** 13.0 or later
- **Xcode** 15.0 or later
- **iOS Deployment Target**: iOS 17.0 or later

## Getting Started

### Opening the Project

1. Navigate to the iOS directory:
   ```bash
   cd ios/DyadSampleApp
   ```

2. Open the project in Xcode:
   ```bash
   open DyadSampleApp.xcodeproj
   ```

### Building the App

#### Using Xcode:
1. Open `DyadSampleApp.xcodeproj` in Xcode
2. Select a target device or simulator
3. Press `Cmd + B` to build or `Cmd + R` to run

#### Using Command Line:
```bash
# Build for iOS Simulator
xcodebuild -project DyadSampleApp.xcodeproj \
  -scheme DyadSampleApp \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  build

# Build for iOS Device
xcodebuild -project DyadSampleApp.xcodeproj \
  -scheme DyadSampleApp \
  -sdk iphoneos \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO \
  build
```

### Running Tests

#### Using Xcode:
- Press `Cmd + U` to run all tests

#### Using Command Line:
```bash
xcodebuild test \
  -project DyadSampleApp.xcodeproj \
  -scheme DyadSampleApp \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Project Structure

```
DyadSampleApp/
├── DyadSampleApp/
│   ├── DyadSampleAppApp.swift    # App entry point
│   ├── ContentView.swift          # Main UI view
│   ├── NetworkService.swift       # Networking layer
│   ├── Assets.xcassets/           # App assets and icons
│   └── Preview Content/           # Preview assets for SwiftUI
├── DyadSampleAppTests/
│   └── DyadSampleAppTests.swift   # Unit tests
└── DyadSampleApp.xcodeproj/       # Xcode project file
```

## Code Overview

### Main Components

1. **DyadSampleAppApp.swift**: The entry point of the app using the `@main` attribute and SwiftUI's App protocol.

2. **ContentView.swift**: The main view that displays a list of posts fetched from a REST API. Includes error handling and loading states.

3. **NetworkService.swift**: A singleton service that handles network requests using URLSession. Implements proper error handling and async completion handlers.

4. **DyadSampleAppTests.swift**: Unit tests covering model decoding and network service functionality.

## Linting and Code Style

To maintain code quality, we recommend using SwiftLint:

### Installing SwiftLint:
```bash
# Using Homebrew
brew install swiftlint

# Using Mint
mint install realm/SwiftLint
```

### Running SwiftLint:
```bash
cd ios/DyadSampleApp
swiftlint
```

## Troubleshooting

### Common Issues

1. **Build fails with "No signing certificate found"**
   - For CI/CD: Use the command line build with `CODE_SIGNING_REQUIRED=NO`
   - For local development: Select your development team in Xcode's project settings

2. **Simulator not available**
   - Ensure Xcode Command Line Tools are installed:
     ```bash
     xcode-select --install
     ```

3. **Network requests fail**
   - Check that you have an internet connection
   - Verify the API endpoint is accessible

## Mobile-Specific Features

This sample app can be extended with:

### Push Notifications
Add the Push Notifications capability in Xcode and implement:
- APNs registration
- Remote notification handling
- Background fetch

### In-App Purchases
Configure in-app purchases through:
- App Store Connect
- StoreKit 2 framework
- Purchase verification

### Offline Caching
Implement data persistence using:
- Core Data for complex data models
- UserDefaults for simple key-value storage
- File system for large data caching

### Example: Adding Core Data
```swift
import CoreData

// Add to your app
let persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "DataModel")
    container.loadPersistentStores { description, error in
        if let error = error {
            fatalError("Unable to load persistent stores: \(error)")
        }
    }
    return container
}()
```

## Contributing

When contributing to the iOS app:

1. Follow Swift naming conventions and style guidelines
2. Write unit tests for new functionality
3. Update documentation for significant changes
4. Run SwiftLint before committing
5. Test on multiple iOS versions and device sizes

## Resources

- [Swift Documentation](https://swift.org/documentation/)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [Xcode Documentation](https://developer.apple.com/xcode/)

## License

This sample app is part of the Dyad project and follows the same licensing as the main repository.
