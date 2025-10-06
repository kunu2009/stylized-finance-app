# App Icon Setup Instructions

## 📱 How to Set Your Custom App Icon

### Step 1: Save the Icon Image
1. Save your "7K Money" logo image (the one with 7K text and money bag)
2. Name it: `icon.png`
3. Place it in: `assets/app_icon/icon.png`

**Requirements:**
- Format: PNG
- Recommended size: 1024x1024 pixels (minimum 512x512)
- Background: Transparent or solid color
- File name: `icon.png`

### Step 2: Generate Icons
After placing your icon image, run these commands:

```bash
# Install/update the flutter_launcher_icons package
flutter pub get

# Generate all icon sizes for Android and iOS
flutter pub run flutter_launcher_icons

# Or use the shorthand
dart run flutter_launcher_icons
```

### Step 3: Rebuild the App
```bash
# Clean previous builds
flutter clean

# Build the APK
flutter build apk --release

# Or build and install directly
flutter run --release
```

### Step 4: Verify
1. Install the APK on your device
2. Check the app icon in:
   - App drawer (list of all apps)
   - Home screen (when you place the app shortcut)
   - Recent apps screen
   - Settings → Apps

## 🎨 Icon Specifications

### Android Icons Generated:
- **mipmap-mdpi**: 48x48 px
- **mipmap-hdpi**: 72x72 px
- **mipmap-xhdpi**: 96x96 px
- **mipmap-xxhdpi**: 144x144 px
- **mipmap-xxxhdpi**: 192x192 px

### Adaptive Icons (Android 8.0+):
- **Background**: #1E1E1E (dark color)
- **Foreground**: Your logo
- **Total size**: 108x108 dp (with safe zone)

## 📁 Current Setup

Your `pubspec.yaml` is configured with:
- Image path: `assets/app_icon/icon.png`
- Adaptive background: `#1E1E1E` (dark gray/black)
- Platforms: Android + iOS

## ⚠️ Important Notes

1. **Image Quality**: Use high-resolution PNG (1024x1024) for best results
2. **Transparency**: Supported on Android, but ensure adaptive icon has proper background
3. **Safe Zone**: Keep important content within center 66% of image (Android adaptive icons)
4. **Testing**: Test on different Android versions to see adaptive vs legacy icons

## 🔄 Updating the Icon Later

To update the icon:
1. Replace `assets/app_icon/icon.png` with new image
2. Run `flutter pub run flutter_launcher_icons`
3. Rebuild the app
4. Uninstall old version
5. Install new APK

## 🎯 Quick Start

If you have your icon ready:
```bash
# 1. Put your icon.png in assets/app_icon/
# 2. Run these commands:
flutter pub get
flutter pub run flutter_launcher_icons
flutter build apk --release
```

Done! Your icon will be set for the app.
