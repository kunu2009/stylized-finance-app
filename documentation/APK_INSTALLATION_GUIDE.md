# 📱 How to Install the APK

## APK Location
The release APK file is located at:
```
C:\Desktop\finance app\build\app\outputs\flutter-apk\app-release.apk
```

**File Size**: 21.7MB

---

## Installation Steps

### On Android Device:

1. **Transfer the APK**:
   - Connect your Android device to your computer
   - Copy `app-release.apk` to your device's Downloads folder
   - OR use cloud storage (Google Drive, Dropbox) to transfer

2. **Enable Unknown Sources**:
   - Go to **Settings** > **Security** (or **Privacy**)
   - Enable **Install from Unknown Sources**
   - OR for Android 8+: Allow installation from the app you'll use to open the APK (e.g., Files app)

3. **Install the APK**:
   - Open the **Files** app on your Android device
   - Navigate to **Downloads**
   - Tap on `app-release.apk`
   - Tap **Install**
   - Wait for installation to complete
   - Tap **Open** to launch the app

---

## Features Available in APK

✅ **Working Features**:
- Dashboard with balance overview
- Add Income, Expense, Lending, Borrowing transactions
- Budget management with category tracking
- Statistics with charts (pie charts, bar charts)
- Recurring transactions (auto-process on startup)
- Smart reminders for loans and goals
- Advanced search with filters
- Dark mode (Light/Dark/System)
- Settings and preferences
- All data persisted locally using shared_preferences

⚠️ **Limited Features**:
- **Import/Export**: Not available on mobile (web only)
  - This requires additional packages like `file_picker` or `share`
  - Data is still saved locally and persists between app launches

---

## Testing the App

After installation, test these features:

1. **Add Transactions**:
   - Tap the large **+** button in the center of the bottom dock
   - Try adding different transaction types (Income, Expense, etc.)
   - Verify they appear on the Dashboard

2. **Set Budgets**:
   - Go to **Budget** tab
   - Tap **+** to add category budgets
   - Watch the progress bars update as you add expenses

3. **View Statistics**:
   - Go to **Statistics** tab
   - See pie charts of spending by category
   - View bar charts of monthly trends

4. **Dark Mode**:
   - Go to **Settings** (gear icon in Dashboard)
   - Toggle between Light/Dark/System theme
   - App should switch immediately

5. **Recurring Transactions**:
   - Go to **Settings** > **Recurring Transactions**
   - Add a recurring transaction (daily/weekly/monthly)
   - Close and reopen the app to see it auto-process

6. **Reminders**:
   - Go to **Settings** > **Reminders**
   - View auto-generated reminders for loans
   - Add custom reminders

7. **Search**:
   - Go to **Search** (magnifying glass icon)
   - Try searching for transactions by keyword
   - Use filters (type, category, date range)

---

## Troubleshooting

**Issue**: "App not installed" error
- **Solution**: Make sure you have enough storage space (need ~50MB free)
- **Solution**: Uninstall any previous version first

**Issue**: "Installation blocked" message
- **Solution**: Enable installation from unknown sources in Settings
- **Solution**: On Android 8+, allow installation from the specific app (Files, Chrome, etc.)

**Issue**: App crashes on startup
- **Solution**: Clear app data: Settings > Apps > Finance Tracker > Clear Data
- **Solution**: Uninstall and reinstall

**Issue**: Data not saving
- **Solution**: Make sure the app has storage permissions
- **Solution**: Check if "Don't keep activities" is disabled in Developer Options

---

## Development Build Info

- **Build Type**: Release
- **Target SDK**: 34 (Android 14)
- **Min SDK**: 21 (Android 5.0 Lollipop)
- **Architecture**: Universal (arm64-v8a, armeabi-v7a, x86_64)
- **Build Time**: ~11 minutes
- **Flutter Version**: 3.8.1+
- **Dart Version**: 3.5.4+

---

## Need Help?

- **GitHub Repository**: https://github.com/kunu2009/stylized-finance-app
- **Source Code**: Available in the repository
- **Documentation**: See `documentation/` folder for feature details

---

## 🎉 Enjoy Your Finance Tracker!

The app is now ready to help you manage your finances with:
- ₹ Indian Rupee formatting
- Beautiful dark mode
- Comprehensive transaction tracking
- Budget management
- Smart reminders
- And much more!
