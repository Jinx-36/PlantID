# PlantID

PlantID is a clean, modern Flutter application that allows you to identify plants using your camera and get specialized care advice.

## 🚀 Features

- **Plant Identification**: Take a photo or pick one from your gallery to identify species using the PlantNet API.
- **Care Advice**: Get watering, sunlight, and soil requirements from the OpenFarm API.
- **Scan History**: Keep a local record of all your plant scans.
- **Offline Support**: Visual indicators when you're offline.
- **Modern UI**: Clean, nature-themed design using the Poppins font.

---

## 🛠 Setup & Installation

### 1. Prerequisites
- **Flutter SDK**: [Install Flutter](https://docs.flutter.dev/get-started/install). Ensure you are on the `stable` channel.
- **Java**: Java 17 is required for Android builds.
- **Android Studio / Xcode**: Required for mobile development and emulators.

### 2. Clone the Repository
```bash
git clone https://github.com/Jinx-36/PlantID.git
cd PlantID
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. API Configuration
The app uses a public demo key for PlantNet in `lib/core/constants.dart`.
If you want to use your own:
1. Get a key from [PlantNet API](https://my.api.plantnet.org/).
2. Replace `plantNetApiKey` in `lib/core/constants.dart`.

---

## 📱 Running the App

### Launch on Web (Chrome)
```bash
flutter run -d chrome
```

### Launch on Android (Emulator or Physical Device)
```bash
flutter run -d android
```

---

## 📦 Building for Android (APK)

To generate an APK file that you can install on your phone:

1. **Build the APK**:
   ```bash
   flutter build apk --debug
   ```
   *(Note: Using `--debug` for easier initial testing. Use `--release` for production, which requires signing.)*

2. **Locate the file**:
   The generated file will be at `build/app/outputs/flutter-apk/app-debug.apk`.

### How to install on your phone:
1. Transfer the `app-debug.apk` file to your phone (via USB, Google Drive, email, etc.).
2. On your phone, open a File Manager and find the APK.
3. Tap the APK to install.
4. **Important**: If prompted, allow "Installation from unknown sources" or "Trust this source" in your Android settings.
5. Launch "PlantID" from your app drawer.

---

## 🛠 Troubleshooting

### Dependency Errors
If you see errors like `The argument type '...' can't be assigned to the parameter type '...'`, ensure your dependencies are up to date:
```bash
flutter pub upgrade
```

### Android Build Issues
Ensure your `JAVA_HOME` points to Java 17. You can check your version with:
```bash
java -version
```

---

## 🧪 Running Tests
```bash
flutter test
```

## 🏗 Project Structure
- `lib/core`: Theme and constants.
- `lib/models`: Data structures.
- `lib/services`: API and Database logic.
- `lib/providers`: State management with Riverpod.
- `lib/screens`: Full-screen UI components.
- `lib/widgets`: Reusable UI components.
