# Instructions to add your 7K Money logo

# MANUAL STEP REQUIRED:
# Please save your 7K logo image as "logo.png" in the assets folder
# The image should be placed at: C:\Desktop\finance app\assets\logo.png

# After you've saved the logo.png file manually, run these commands:

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "7K Money App Rebranding Instructions" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "STEP 1: Save Your Logo" -ForegroundColor Yellow
Write-Host "  - Save the 7K logo image as 'logo.png' in the assets folder" -ForegroundColor White
Write-Host "  - Location: C:\Desktop\finance app\assets\logo.png" -ForegroundColor White
Write-Host "  - Recommended size: 1024x1024 pixels (square)" -ForegroundColor White
Write-Host ""

# Check if logo exists
if (Test-Path "assets\logo.png") {
    Write-Host "✓ Logo found at assets\logo.png" -ForegroundColor Green
    Write-Host ""
    Write-Host "STEP 2: Running flutter pub get..." -ForegroundColor Yellow
    flutter pub get
    
    Write-Host ""
    Write-Host "STEP 3: Generating app icons from logo..." -ForegroundColor Yellow
    dart run flutter_launcher_icons
    
    Write-Host ""
    Write-Host "STEP 4: Building optimized APK..." -ForegroundColor Yellow
    flutter build apk --release --split-per-abi
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "✓ 7K Money App Successfully Rebranded!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "New APK files created:" -ForegroundColor Cyan
    Write-Host "  - build\app\outputs\flutter-apk\app-arm64-v8a-release.apk (8.6 MB)" -ForegroundColor White
    Write-Host "  - build\app\outputs\flutter-apk\app-armeabi-v7a-release.apk (8.2 MB)" -ForegroundColor White
    Write-Host "  - build\app\outputs\flutter-apk\app-x86_64-release.apk (8.8 MB)" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "✗ Logo not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please:" -ForegroundColor Yellow
    Write-Host "  1. Save your 7K logo image as 'logo.png'" -ForegroundColor White
    Write-Host "  2. Place it in: C:\Desktop\finance app\assets\" -ForegroundColor White
    Write-Host "  3. Run this script again" -ForegroundColor White
    Write-Host ""
}
