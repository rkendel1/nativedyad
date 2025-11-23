# Dyad

Dyad is a local, open-source AI app builder. It's fast, private, and fully under your control — like Lovable, v0, or Bolt, but running right on your machine.

[![Image](https://github.com/user-attachments/assets/f6c83dfc-6ffd-4d32-93dd-4b9c46d17790)](https://dyad.sh/)

More info at: [https://dyad.sh/](https://dyad.sh/)

## 🚀 Features

- ⚡️ **Local**: Fast, private and no lock-in.
- 🛠 **Bring your own keys**: Use your own AI API keys — no vendor lock-in.
- 🖥️ **Cross-platform**: Easy to run on Mac or Windows.
- 📱 **iOS App Builder**: Create native iOS apps with Swift and SwiftUI.

## 📦 Download

No sign-up required. Just download and go.

### [👉 Download for your platform](https://www.dyad.sh/#download)

## 🤝 Community

Join our growing community of AI app builders on **Reddit**: [r/dyadbuilders](https://www.reddit.com/r/dyadbuilders/) - share your projects and get help from the community!

## 📱 iOS Development

Dyad now supports building native iOS applications! The repository includes tools and examples for creating Swift-based iOS apps.

### Getting Started with iOS

#### Prerequisites

To build iOS apps, you need:
- **macOS** 13.0 or later
- **Xcode** 15.0 or later
- **Swift** 5.9 or later (included with Xcode)
- **CocoaPods** or **Swift Package Manager** (for dependencies)

#### Quick Start

1. Navigate to the iOS sample app:
   ```bash
   cd ios/DyadSampleApp
   ```

2. Open the project in Xcode:
   ```bash
   open DyadSampleApp.xcodeproj
   ```

3. Build and run the app (⌘+R)

For detailed instructions, see the [iOS README](./ios/README.md).

### iOS Sample App

The repository includes a fully functional sample iOS app (`ios/DyadSampleApp`) featuring:
- 📱 SwiftUI-based user interface with modern design
- 🌐 Networking capabilities using URLSession
- 🧪 Unit tests with XCTest framework
- 🎨 Clean architecture and separation of concerns

### CI/CD Pipeline for iOS

Our GitHub Actions workflow automatically:
- ✅ Builds the iOS project on every push/PR
- 🧪 Runs unit tests on iOS simulators
- 🔍 Performs SwiftLint code style checks
- 📦 Packages build artifacts

The iOS CI/CD pipeline runs on `macos-latest` and is configured in [`.github/workflows/ios-ci.yml`](.github/workflows/ios-ci.yml).

### Mobile-Specific Features

The iOS app builder supports integration of advanced mobile features:

#### Push Notifications
- Configure APNs (Apple Push Notification service)
- Handle remote and local notifications
- Implement background notification processing

#### In-App Purchases
- Set up StoreKit integration
- Configure products in App Store Connect
- Implement purchase validation and receipt verification

#### Offline Caching
- Use Core Data for persistent storage
- Implement URLCache for network response caching
- Store user preferences with UserDefaults

For implementation details, see the [iOS Development Guide](./ios/README.md#mobile-specific-features).

### Contributing to iOS

We welcome contributions to the iOS app builder! To contribute:

1. **Fork and clone** the repository
2. **Create a feature branch** for your changes
3. **Follow Swift style guidelines** and run SwiftLint
4. **Write unit tests** for new functionality
5. **Update documentation** as needed
6. **Submit a pull request** with a clear description

See our [CONTRIBUTING.md](./CONTRIBUTING.md) for general contribution guidelines.

## 🛠️ Contributing

**Dyad** is open-source (Apache 2.0 licensed).

If you're interested in contributing to dyad, please read our [contributing](./CONTRIBUTING.md) doc.

## License

- All the code in this repo outside of `src/pro` is open-source and licensed under Apache 2.0 - see [LICENSE](./LICENSE).
- All the code in this repo within `src/pro` is fair-source and licensed under [Functional Source License 1.1 Apache 2.0](https://fsl.software/) - see [LICENSE](./src/pro/LICENSE).
