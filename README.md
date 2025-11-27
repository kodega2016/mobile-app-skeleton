# 🚀 Quick Setup Guide

Follow these steps to get your Flutter Boilerplate up and running:

## 1. Install Dependencies

```bash
flutter pub get
```

## 2. Generate Required Files

This project uses code generation for Freezed, JSON serialization, and Hive. Run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate:
- `*.freezed.dart` - Freezed data classes
- `*.g.dart` - JSON serialization & Hive adapters
- `test_helper.mocks.dart` - Test mocks

### During Development

Use watch mode to auto-generate on file changes:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## 3. Fix Common Issues

### Issue: GetIt Registration Error

If you see:
```
Bad state: GetIt: Object/factory with type X is not registered
```

**Solution:** Make sure `lib/core/di/injection.dart` includes all dependencies. Check that:
- All use cases are registered
- All repositories are registered  
- All data sources are registered
- Services are registered before they're used

### Issue: Missing Generated Files

If you see errors about missing `.freezed.dart` or `.g.dart` files:

**Solution:** Run code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Hive Box Not Found

If you see Hive box errors:

**Solution:** Hive is initialized in `main.dart`. Ensure:
```dart
await Hive.initFlutter();
await configureDependencies(); // This calls HiveService.init()
```

## 4. Configure Your API

Update `lib/core/constants/api_constants.dart`:

```dart
class ApiConstants {
  static const String baseUrl = 'https://your-api-url.com/api/v1';
  // ... rest of endpoints
}
```

## 5. Platform-Specific Setup

### Android

1. Update `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest>
    <!-- Add permissions -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    
    <application>
        <!-- Your app config -->
    </application>
</manifest>
```

2. Minimum SDK version in `android/app/build.gradle`:

```gradle
android {
    defaultConfig {
        minSdkVersion 21  // Minimum for this project
    }
}
```

### iOS

1. Update `ios/Runner/Info.plist`:

```xml
<dict>
    <!-- Add network permissions -->
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>
    
    <!-- Add notification permissions -->
    <key>UIBackgroundModes</key>
    <array>
        <string>fetch</string>
        <string>remote-notification</string>
    </array>
</dict>
```

2. Minimum iOS version in `ios/Podfile`:

```ruby
platform :ios, '12.0'
```

## 6. Run the App

```bash
# Run on connected device/emulator
flutter run

# Run in release mode
flutter run --release

# Run on specific device
flutter run -d <device_id>
```

## 7. Run Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# View coverage (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 8. Project Structure Overview

```
lib/
├── core/                      # Core functionality
│   ├── di/injection.dart     # ⚠️ IMPORTANT: Dependency Injection
│   ├── network/              # HTTP client
│   ├── services/             # Core services
│   └── theme/                # Theming
├── features/
│   └── auth/
│       ├── data/             # Data layer
│       ├── domain/           # Business logic
│       └── presentation/     # UI
└── main.dart                 # App entry point
```

## 9. Common Commands

```bash
# Clean build
flutter clean && flutter pub get

# Check for issues
flutter doctor

# Analyze code
flutter analyze

# Format code
flutter format lib/

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for code generation
flutter pub run build_runner watch

# Run tests
flutter test

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release
```

## 10. Troubleshooting

### App doesn't start
1. Run `flutter clean`
2. Run `flutter pub get`
3. Run code generation
4. Restart IDE
5. Try again

### Code generation fails
1. Check for syntax errors in models
2. Ensure all imports are correct
3. Delete conflicting outputs: `flutter pub run build_runner build --delete-conflicting-outputs`

### Dependency injection errors
1. Check `injection.dart` - all dependencies must be registered
2. Verify order - dependencies must be registered before use
3. Use `getIt<Type>()` to retrieve, not `getIt()`

### Test failures
1. Generate test mocks: `flutter pub run build_runner build`
2. Check mock configurations in `test/helpers/test_helper.dart`
3. Verify test fixtures in `test/fixtures/`

## 11. Next Steps

✅ Configure your API endpoints  
✅ Add your app branding (logo, colors, name)  
✅ Implement your features following the auth example  
✅ Write tests for new features  
✅ Customize themes in `app_theme_data.dart`  

## 12. Development Workflow

1. Create feature in `lib/features/your_feature/`
2. Follow Clean Architecture (domain → data → presentation)
3. Use Freezed for data classes and states
4. Register dependencies in `injection.dart`
5. Write tests in `test/features/your_feature/`
6. Run code generation
7. Test and iterate

## Need Help?

- Check `README.md` for detailed documentation
- Review `PROJECT_STRUCTURE.md` for architecture details
- Look at the `auth` feature as a reference implementation
- All code includes comments for guidance

Happy coding! 🎉