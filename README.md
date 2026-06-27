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
- **Flutter SDK**: [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Dart SDK**: Included with Flutter.
- **Android Studio / Xcode**: For mobile development.

### 2. Clone the Repository
```bash
git clone <repository-url>
cd plantid
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

### Launch on Web
```bash
flutter run -d chrome
```

### Launch on Android (Emulator or Physical Device)
```bash
flutter run
```

---

## 📦 Building for Android (APK)

To generate an APK file that you can install on your phone:

1. **Build the APK**:
   ```bash
   flutter build apk --release
   ```
2. **Locate the file**:
   The generated file will be at `build/app/outputs/flutter-apk/app-release.apk`.

### How to install on your phone:
1. Transfer the `app-release.apk` file to your phone (via USB, Google Drive, etc.).
2. On your phone, open the file.
3. If prompted, allow "Installation from unknown sources" in your settings.
4. Follow the prompts to install.

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
