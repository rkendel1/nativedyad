# Mobile-Specific Enhancements Guide

This guide provides detailed information on integrating advanced mobile features into iOS apps built with the Dyad iOS app builder.

## Table of Contents

- [Push Notifications](#push-notifications)
- [In-App Purchases](#in-app-purchases)
- [Offline Caching](#offline-caching)
- [Additional Features](#additional-features)

## Push Notifications

Push notifications allow your app to send timely information to users even when the app isn't running.

### Setup Requirements

1. **Apple Developer Account**: Required for APNs configuration
2. **App ID with Push Notifications enabled** in Apple Developer Portal
3. **APNs Certificate or Token** for your app

### Implementation Steps

#### 1. Enable Push Notifications Capability

In Xcode:
1. Select your project in the navigator
2. Select your target
3. Go to "Signing & Capabilities"
4. Click "+ Capability" and add "Push Notifications"

#### 2. Request User Permission

```swift
import UserNotifications

func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if granted {
            print("Notification permission granted")
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        } else if let error = error {
            print("Error requesting notifications: \(error)")
        }
    }
}
```

#### 3. Handle Device Token Registration

Add to your App delegate or App struct:

```swift
func application(_ application: UIApplication, 
                didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    print("Device Token: \(token)")
    // Send token to your backend server
}

func application(_ application: UIApplication, 
                didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Failed to register for remote notifications: \(error)")
}
```

#### 4. Handle Incoming Notifications

```swift
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Handle notification when app is in foreground
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle notification tap
        let userInfo = response.notification.request.content.userInfo
        print("Notification tapped with info: \(userInfo)")
        completionHandler()
    }
}
```

### Best Practices

- Always request permission at an appropriate time in the user journey
- Provide clear explanation of why notifications are needed
- Allow users to customize notification preferences in-app
- Test with both production and sandbox APNs environments

## In-App Purchases

In-app purchases enable monetization through digital goods and subscriptions.

### Setup Requirements

1. **Paid Apple Developer Account**
2. **App Store Connect** access
3. **StoreKit** configured in Xcode
4. **Products configured** in App Store Connect

### Implementation Steps

#### 1. Configure In-App Purchase Capability

In Xcode:
1. Select your target
2. Go to "Signing & Capabilities"
3. Add "In-App Purchase" capability

#### 2. Create Products in App Store Connect

1. Navigate to your app in App Store Connect
2. Go to "Features" → "In-App Purchases"
3. Create products (consumable, non-consumable, subscriptions)
4. Set product IDs, pricing, and descriptions

#### 3. Implement StoreKit 2

```swift
import StoreKit

class StoreManager: ObservableObject {
    @Published var products: [Product] = []
    @Published var purchasedProducts: Set<String> = []
    
    private let productIDs = ["com.dyad.premium", "com.dyad.tokens.100"]
    
    init() {
        Task {
            await loadProducts()
            await updatePurchasedProducts()
        }
    }
    
    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
        } catch {
            print("Failed to load products: \(error)")
        }
    }
    
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            await updatePurchasedProducts()
            return transaction
        case .userCancelled:
            return nil
        case .pending:
            return nil
        @unknown default:
            return nil
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.revocationDate == nil {
                purchasedProducts.insert(transaction.productID)
            } else {
                purchasedProducts.remove(transaction.productID)
            }
        }
    }
}

enum StoreError: Error {
    case failedVerification
}
```

#### 4. Create Purchase UI

```swift
struct PurchaseView: View {
    @StateObject private var store = StoreManager()
    
    var body: some View {
        List(store.products) { product in
            HStack {
                VStack(alignment: .leading) {
                    Text(product.displayName)
                        .font(.headline)
                    Text(product.description)
                        .font(.caption)
                }
                
                Spacer()
                
                Button(product.displayPrice) {
                    Task {
                        try? await store.purchase(product)
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("In-App Purchases")
    }
}
```

### Best Practices

- Always verify receipts on your server for security
- Handle all purchase states (success, pending, cancelled, failed)
- Restore purchases for users who reinstall the app
- Test thoroughly with sandbox accounts
- Provide clear purchase descriptions and terms

## Offline Caching

Offline caching improves user experience by allowing the app to function without connectivity.

### Strategy 1: Core Data for Structured Data

#### 1. Create Data Model

Create a `.xcdatamodeld` file in Xcode with your entities.

#### 2. Set Up Core Data Stack

```swift
import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DyadModel")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
```

#### 3. Integrate with SwiftUI

```swift
@main
struct DyadSampleAppApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
```

#### 4. Save and Fetch Data

```swift
class DataManager {
    let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }
    
    func savePost(id: Int, title: String, body: String) {
        let post = CachedPost(context: viewContext)
        post.id = Int64(id)
        post.title = title
        post.body = body
        post.cachedAt = Date()
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to save: \(error)")
        }
    }
    
    func fetchPosts() -> [CachedPost] {
        let request: NSFetchRequest<CachedPost> = CachedPost.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CachedPost.cachedAt, ascending: false)]
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Failed to fetch: \(error)")
            return []
        }
    }
}
```

### Strategy 2: URLCache for Network Responses

```swift
class CacheManager {
    static func configureURLCache() {
        // 50 MB memory cache, 100 MB disk cache
        let cache = URLCache(
            memoryCapacity: 50 * 1024 * 1024,
            diskCapacity: 100 * 1024 * 1024,
            diskPath: "network_cache"
        )
        URLCache.shared = cache
    }
    
    static func cachePolicy(isOnline: Bool) -> URLRequest.CachePolicy {
        return isOnline ? .useProtocolCachePolicy : .returnCacheDataDontLoad
    }
}

// In your NetworkService
func fetchPosts(isOnline: Bool, completion: @escaping (Result<[Post], Error>) -> Void) {
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
        completion(.failure(NetworkError.invalidURL))
        return
    }
    
    var request = URLRequest(url: url)
    request.cachePolicy = CacheManager.cachePolicy(isOnline: isOnline)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        // Handle response
    }
    
    task.resume()
}
```

### Strategy 3: UserDefaults for Simple Data

```swift
class SettingsManager {
    private enum Keys {
        static let userPreferences = "userPreferences"
        static let lastSyncDate = "lastSyncDate"
    }
    
    static func savePreferences(_ preferences: [String: Any]) {
        UserDefaults.standard.set(preferences, forKey: Keys.userPreferences)
    }
    
    static func loadPreferences() -> [String: Any]? {
        return UserDefaults.standard.dictionary(forKey: Keys.userPreferences)
    }
    
    static func saveLastSyncDate(_ date: Date) {
        UserDefaults.standard.set(date, forKey: Keys.lastSyncDate)
    }
    
    static func loadLastSyncDate() -> Date? {
        return UserDefaults.standard.object(forKey: Keys.lastSyncDate) as? Date
    }
}
```

### Best Practices

- Implement a cache expiration strategy
- Monitor storage usage and clean up old data
- Sync local changes when connectivity returns
- Handle conflicts between local and remote data
- Provide clear UI indication of offline mode

## Additional Features

### Background App Refresh

Enable background updates:

```swift
import BackgroundTasks

func scheduleBackgroundRefresh() {
    let request = BGAppRefreshTaskRequest(identifier: "com.dyad.refresh")
    request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15 minutes
    
    do {
        try BGTaskScheduler.shared.submit(request)
    } catch {
        print("Could not schedule app refresh: \(error)")
    }
}
```

### Biometric Authentication

Implement Face ID/Touch ID:

```swift
import LocalAuthentication

func authenticateUser(completion: @escaping (Bool, Error?) -> Void) {
    let context = LAContext()
    var error: NSError?
    
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        let reason = "Authenticate to access your account"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
            completion(success, error)
        }
    } else {
        completion(false, error)
    }
}
```

### App Clips

Create lightweight app experiences:

1. Add App Clip target in Xcode
2. Keep size under 10MB
3. Use simple, focused functionality
4. Implement App Clip-specific UI

### Widgets

Add home screen widgets:

```swift
import WidgetKit
import SwiftUI

struct DyadWidget: Widget {
    let kind: String = "DyadWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DyadWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Dyad Widget")
        .description("Quick access to Dyad features")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
```

## Testing Mobile Features

### Unit Testing

```swift
func testOfflineCache() {
    let expectation = XCTestExpectation(description: "Cache saves data")
    
    dataManager.savePost(id: 1, title: "Test", body: "Test Body")
    let posts = dataManager.fetchPosts()
    
    XCTAssertEqual(posts.count, 1)
    XCTAssertEqual(posts.first?.title, "Test")
    expectation.fulfill()
    
    wait(for: [expectation], timeout: 5.0)
}
```

### UI Testing

```swift
func testPurchaseFlow() {
    let app = XCUIApplication()
    app.launch()
    
    app.buttons["Purchase"].tap()
    
    // Verify purchase screen appears
    XCTAssertTrue(app.staticTexts["Premium Features"].exists)
}
```

## Resources

- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [Core Data Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/)
- [StoreKit Documentation](https://developer.apple.com/documentation/storekit)
- [UserNotifications Framework](https://developer.apple.com/documentation/usernotifications)

## Support

For questions or issues related to mobile feature implementation, please:
1. Check the iOS README for basic information
2. Review Apple's official documentation
3. Open an issue on GitHub with detailed description
4. Join our community discussions on Reddit: [r/dyadbuilders](https://www.reddit.com/r/dyadbuilders/)
