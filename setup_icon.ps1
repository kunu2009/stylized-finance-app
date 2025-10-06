# 7K Money - App Icon Setup Script
# Run this script after saving your icon image as: assets/app_icon/icon.png

Write-Host "🎨 7K Money - App Icon Generator" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

# Check if icon file exists
$iconPath = "assets/app_icon/icon.png"
if (-Not (Test-Path $iconPath)) {
    Write-Host "❌ Icon file not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please save your icon image as: $iconPath" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Steps:" -ForegroundColor Yellow
    Write-Host "1. Save the 7K Money logo (with money bag) as 'icon.png'" -ForegroundColor White
    Write-Host "2. Place it in the 'assets/app_icon/' folder" -ForegroundColor White
    Write-Host "3. Run this script again" -ForegroundColor White
    Write-Host ""
    
    # Open the folder for user convenience
    Start-Process "assets\app_icon"
    
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "✅ Icon file found: $iconPath" -ForegroundColor Green
Write-Host ""

# Step 1: Get dependencies
Write-Host "📦 Step 1: Getting Flutter dependencies..." -ForegroundColor Cyan
flutter pub get

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to get dependencies" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "✅ Dependencies updated" -ForegroundColor Green
Write-Host ""

# Step 2: Generate launcher icons
Write-Host "🎨 Step 2: Generating app icons for all resolutions..." -ForegroundColor Cyan
Write-Host "   This will create icons for:" -ForegroundColor White
Write-Host "   - App drawer (when you open all apps)" -ForegroundColor White
Write-Host "   - Home screen" -ForegroundColor White
Write-Host "   - Recent apps" -ForegroundColor White
Write-Host "   - All Android versions" -ForegroundColor White
Write-Host ""

flutter pub run flutter_launcher_icons

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to generate icons" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "✅ Icons generated successfully!" -ForegroundColor Green
Write-Host ""

# Step 3: Clean and rebuild
Write-Host "🧹 Step 3: Cleaning previous builds..." -ForegroundColor Cyan
flutter clean

Write-Host "✅ Clean complete" -ForegroundColor Green
Write-Host ""

Write-Host "🔨 Step 4: Building APK with new icon..." -ForegroundColor Cyan
Write-Host "   This may take a few minutes..." -ForegroundColor White
Write-Host ""

flutter build apk --release

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "✅ APK built successfully!" -ForegroundColor Green
Write-Host ""

# Copy APK to web downloads
Write-Host "📦 Step 5: Copying APK to web downloads..." -ForegroundColor Cyan
$apkSource = "build\app\outputs\flutter-apk\app-release.apk"
$apkDest = "web\downloads\7k-money.apk"

Copy-Item $apkSource $apkDest -Force

Write-Host "✅ APK copied to: $apkDest" -ForegroundColor Green
Write-Host ""

# Get APK size
$apkSize = (Get-Item $apkDest).Length / 1MB
$apkSizeFormatted = "{0:N2}" -f $apkSize

# Summary
Write-Host "=================================" -ForegroundColor Cyan
Write-Host "🎉 SUCCESS! Icon Setup Complete!" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📱 Your new app icon is now set for:" -ForegroundColor White
Write-Host "   ✓ App drawer (all apps list)" -ForegroundColor Green
Write-Host "   ✓ Home screen" -ForegroundColor Green
Write-Host "   ✓ Recent apps" -ForegroundColor Green
Write-Host "   ✓ Settings → Apps" -ForegroundColor Green
Write-Host ""
Write-Host "📦 New APK Details:" -ForegroundColor White
Write-Host "   Location: $apkDest" -ForegroundColor White
Write-Host "   Size: $apkSizeFormatted MB" -ForegroundColor White
Write-Host ""
Write-Host "🚀 Next Steps:" -ForegroundColor Yellow
Write-Host "   1. Install the new APK on your phone" -ForegroundColor White
Write-Host "   2. Check the app drawer - you'll see your new icon!" -ForegroundColor White
Write-Host "   3. Add to home screen to see it there too" -ForegroundColor White
Write-Host ""
Write-Host "💡 Tip: Uninstall old version first if updating" -ForegroundColor Cyan
Write-Host ""

Read-Host "Press Enter to exit"
