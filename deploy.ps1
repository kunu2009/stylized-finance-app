# 7K Money - Quick Deploy to Vercel
# Run this script to deploy your landing page

Write-Host "🚀 7K Money - Vercel Deployment Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Git is installed
$gitInstalled = Get-Command git -ErrorAction SilentlyContinue
if (-not $gitInstalled) {
    Write-Host "❌ Git is not installed!" -ForegroundColor Red
    Write-Host "Please install Git from: https://git-scm.com/download/win" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Git is installed" -ForegroundColor Green

# Check if already a git repository
if (-not (Test-Path ".git")) {
    Write-Host ""
    Write-Host "📦 Initializing Git repository..." -ForegroundColor Yellow
    git init
    Write-Host "✅ Git repository initialized" -ForegroundColor Green
}

# Add all files
Write-Host ""
Write-Host "📁 Adding files to Git..." -ForegroundColor Yellow
git add .

# Commit
Write-Host ""
Write-Host "💾 Committing changes..." -ForegroundColor Yellow
$commitMessage = Read-Host "Enter commit message (or press Enter for default)"
if ([string]::IsNullOrWhiteSpace($commitMessage)) {
    $commitMessage = "Deploy 7K Money landing page"
}
git commit -m "$commitMessage"

Write-Host "✅ Changes committed" -ForegroundColor Green

# Check for remote
$hasRemote = git remote -v 2>$null
if (-not $hasRemote) {
    Write-Host ""
    Write-Host "🔗 GitHub Setup Required" -ForegroundColor Cyan
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Please follow these steps:" -ForegroundColor Yellow
    Write-Host "1. Go to https://github.com/new" -ForegroundColor White
    Write-Host "2. Create a new repository (e.g., '7k-money-landing')" -ForegroundColor White
    Write-Host "3. Make it Public" -ForegroundColor White
    Write-Host "4. DO NOT initialize with README" -ForegroundColor White
    Write-Host "5. Click 'Create repository'" -ForegroundColor White
    Write-Host ""
    $repoUrl = Read-Host "Enter your GitHub repository URL (e.g., https://github.com/username/repo.git)"
    
    if (-not [string]::IsNullOrWhiteSpace($repoUrl)) {
        git remote add origin $repoUrl
        Write-Host "✅ Remote repository added" -ForegroundColor Green
        
        Write-Host ""
        Write-Host "📤 Pushing to GitHub..." -ForegroundColor Yellow
        git branch -M main
        git push -u origin main
        Write-Host "✅ Code pushed to GitHub!" -ForegroundColor Green
    }
} else {
    Write-Host ""
    Write-Host "📤 Pushing to GitHub..." -ForegroundColor Yellow
    git push
    Write-Host "✅ Code pushed to GitHub!" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎉 Git setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "==========" -ForegroundColor Cyan
Write-Host "1. Go to https://vercel.com" -ForegroundColor White
Write-Host "2. Sign in with GitHub" -ForegroundColor White
Write-Host "3. Click 'Add New Project'" -ForegroundColor White
Write-Host "4. Import your repository" -ForegroundColor White
Write-Host "5. Click 'Deploy'" -ForegroundColor White
Write-Host ""
Write-Host "Your site will be live in ~60 seconds! 🚀" -ForegroundColor Green
Write-Host ""
Write-Host "For detailed instructions, see DEPLOYMENT.md" -ForegroundColor Yellow
Write-Host ""

# Ask if user wants to install Vercel CLI
$installCLI = Read-Host "Do you want to install Vercel CLI for direct deployment? (y/N)"
if ($installCLI -eq 'y' -or $installCLI -eq 'Y') {
    Write-Host ""
    Write-Host "📦 Installing Vercel CLI..." -ForegroundColor Yellow
    Write-Host "This requires Node.js. Installing..." -ForegroundColor Yellow
    
    # Check if npm is available
    $npmInstalled = Get-Command npm -ErrorAction SilentlyContinue
    if ($npmInstalled) {
        npm install -g vercel
        Write-Host "✅ Vercel CLI installed!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Run 'vercel' to deploy directly from command line" -ForegroundColor Cyan
    } else {
        Write-Host "❌ Node.js/npm not found" -ForegroundColor Red
        Write-Host "Please install Node.js from: https://nodejs.org" -ForegroundColor Yellow
        Write-Host "Then run: npm install -g vercel" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "All done! 🎊" -ForegroundColor Green
