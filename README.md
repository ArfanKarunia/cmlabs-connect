# CMLABS Connect App

![CMLABS Connect Cover](assets/images/dokumentation/cover.png)

CMLABS Connect is a Flutter-based application designed to streamline communication and enhance productivity for users. This repository contains the source code, setup instructions, and documentation for development.

This application can accommodate marketing needs in tracking quotations / leads that enter cmlabs. All incoming leads can be seen and tracked easily in the mobile application.

### Goals
Tracking leads masuk dari berbagai channel yang dimiliki oleh cmlabs.co

## Getting Started

### Prequisites

- Flutter SDK: Version 3.0 or higher
- Dart: Version 2.17 or Higher
- JDK: Version 11 (Ensure JAVA_HOME is set to JDK 11)
- Android Studio / Xcode: For Android/Ios Development

### Installation

#### Clone the Repository

- Clone project from repository

  ```
  git clone https://github.com/sequence-project/cmlabs-connect-app.git
  ```

- Open project directory

  ```
  cd cmlabs-connect-app
  ```

#### Install Depedenscies

- in terminal type this command

  ```
  flutter pub get
  ```

#### Set up Configuration

- open file config.dart in "/lib/src/constant/config.dart"

  ```
  lib/
  |- src/
      |- constant/
          |- config.dart  # Application configuration
  ```

- add the link api server

  ```
  class Config{
      static const String baseURL = 'https://your-API-here.com';
  }
  ```

#### Run the Application

```
flutter run
```

#### More Information

A few resources to get you started if this is your Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Deployment

### Android

1. Build APK:

   - Debugging

   ```
   flutter build apk --debug
   ```

   - Release

   ```
   flutter build apk --release
   ```

2. The APK will be available at `build/app/outputs/flutter-apk/app-release.apk`.

### IOS

1. Open the iOS folder in Xcode:

```
open ios/Runner.xcworkspace
```

2. Configure signing and build for release.

## Key Component

### State Management

- `GetX`: Used for efficient state management, routing, and dependency injection.

### Local Storage

- `Hive`: Provides offline data storage for enhanced performance.

### Networking

- `DIO` & `Http`: Ensures robust API communication with error handling.

### Push Notification

- `firebase_messaging`: Real-time push notifications.

- `firebase_core`: Firebase integration setup.

- `flutter_local_notifications`: Manage local notifications.

### Essential Package

The following packages are integral to the functionality and design of the application:

- `sentry_flutter`: Error tracking and reporting.

- `intl`: Internationalization and date formatting.

- `google_fonts`: Custom font integration.

- `flutter_launcher_icons`: Simplify app icon customization.

- `flutter_native_splash`: Configurable splash screens.

- `calendar_date_picker2`: Enhanced date picker widgets.

## CMLABS Connect - Master Design

https://embed.figma.com/design/4NGJ0J8Rm6UlBmlV2H6OZm/cmlabs-Connect?node-id=1-1635&t=CrPHZ8kQ1H1E9TPU-1&embed-host=notion&footer=false&theme=system