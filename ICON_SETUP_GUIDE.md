# 📱 App Icon Setup - Quick Guide

## ⚡ Quick Setup (3 Steps)

### Step 1: Save Your Icon
**IMPORTANT**: Please save the "7K Money" logo (the image you attached with "7K" text and money bag) as:
- **File name**: `icon.png`
- **Location**: `assets/app_icon/icon.png`
- **Size**: 1024x1024 pixels (or at least 512x512)
- **Format**: PNG

### Step 2: Run the Setup Script
Open PowerShell in the project folder and run:
```powershell
.\setup_icon.ps1
```

This will automatically:
- ✅ Generate all icon sizes
- ✅ Update Android icons
- ✅ Build new APK
- ✅ Copy APK to web/downloads/

### Step 3: Install & Check
1. Install the new APK on your phone
2. Open **App Drawer** (all apps list) - You'll see your new icon!
3. Long-press and add to **Home Screen** - Icon appears there too!

---

## 🎯 What Gets Updated

When you run the setup, your icon will appear in:

### App Drawer (All Apps)
- The list where you see all installed apps
- Your "7K Money" logo will be visible here

### Home Screen
- When you add a shortcut
- When you place the app icon

### Other Places
- Recent apps screen
- Settings → Apps
- Notification icons (some cases)

---

## 📁 Manual Method (If Script Doesn't Work)

If the PowerShell script doesn't work, run these commands manually:

```bash
# 1. After saving icon.png in assets/app_icon/

# 2. Get dependencies
flutter pub get

# 3. Generate icons
flutter pub run flutter_launcher_icons

# 4. Build APK
flutter clean
flutter build apk --release

# 5. Copy to web
copy build\app\outputs\flutter-apk\app-release.apk web\downloads\7k-money.apk
```

---

## 🖼️ Icon Requirements

### For Best Results:
- **Size**: 1024x1024 pixels
- **Format**: PNG with transparency
- **Content**: Keep important elements in center 66%
- **Background**: Can be transparent or solid

### Android Adaptive Icons:
- **Foreground**: Your logo
- **Background**: Dark gray (#1E1E1E)
- **Shape**: Varies by device (circle, square, rounded)

---

## ✅ Verification

After installing the new APK:

1. **Open App Drawer**
   - Swipe up from home screen
   - Or tap the apps icon
   - Scroll to find "7K Money"
   - ✅ You should see your new icon!

2. **Add to Home Screen**
   - Long-press the app in app drawer
   - Drag to home screen
   - ✅ Icon appears on home screen!

3. **Check Recent Apps**
   - Tap recent apps button
   - Open and close 7K Money
   - ✅ Icon visible in recent apps!

---

## 🔄 If Icon Doesn't Change

Sometimes Android caches icons. Try these:

1. **Uninstall Old Version**
   ```
   Settings → Apps → 7K Money → Uninstall
   Then install fresh APK
   ```

2. **Clear Launcher Cache**
   ```
   Settings → Apps → Your Launcher → Storage → Clear Cache
   ```

3. **Restart Device**
   ```
   Sometimes needed to refresh icon cache
   ```

---

## 📸 Example Icon Placement

Your icon will look like this in different places:

```
App Drawer:          Home Screen:         Recent Apps:
┌─────────┐         ┌─────────┐          ┌─────────┐
│  [7K💰] │         │  [7K💰] │          │  [7K💰] │
│         │         │         │          │         │
│ 7K Money│         │ 7K Money│          │ 7K Money│
└─────────┘         └─────────┘          └─────────┘
```

---

## 🎨 Current Configuration

Your `pubspec.yaml` is set up with:
```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/app_icon/icon.png"
  adaptive_icon_background: "#1E1E1E"
  adaptive_icon_foreground: "assets/app_icon/icon.png"
```

---

## 💡 Pro Tips

1. **High Resolution**: Use 1024x1024 for best quality
2. **Simple Design**: Icon is small, keep design clear
3. **Recognizable**: Make sure "7K" and money bag are visible
4. **Testing**: Test on different Android versions
5. **Backup**: Keep original high-res icon file safe

---

## 🆘 Need Help?

If you encounter issues:
1. Check `assets/app_icon/INSTRUCTIONS.md` for detailed steps
2. Ensure `icon.png` is in correct folder
3. Make sure image is high quality PNG
4. Try manual commands if script fails

---

**Ready?** Save your icon as `assets/app_icon/icon.png` and run `.\setup_icon.ps1`! 🚀
