# 🚀 Vercel Deployment Guide for 7K Money Landing Page

## Prerequisites

1. **GitHub Account** (free): https://github.com
2. **Vercel Account** (free): https://vercel.com

## 📋 Step-by-Step Deployment

### Method 1: Deploy via Vercel Dashboard (Easiest)

#### Step 1: Push to GitHub

1. Open PowerShell in your project directory:
```powershell
cd "C:\Desktop\finance app"
```

2. Initialize Git (if not already done):
```powershell
git init
git add .
git commit -m "Initial commit - 7K Money Landing Page"
```

3. Create a new repository on GitHub:
   - Go to https://github.com/new
   - Repository name: `7k-money-landing` (or your choice)
   - Make it Public
   - Click "Create repository"

4. Push your code:
```powershell
git remote add origin https://github.com/YOUR_USERNAME/7k-money-landing.git
git branch -M main
git push -u origin main
```

#### Step 2: Deploy to Vercel

1. Go to https://vercel.com and sign in with GitHub

2. Click "Add New Project"

3. Import your repository:
   - Search for `7k-money-landing`
   - Click "Import"

4. Configure your project:
   - **Project Name**: `7k-money` (or your choice)
   - **Framework Preset**: Other
   - **Root Directory**: `./` (leave as is)
   - **Build Command**: Leave empty
   - **Output Directory**: Leave empty

5. Click "Deploy"

6. Wait 30-60 seconds... 🎉 **Your site is live!**

### Method 2: Deploy via Vercel CLI (Advanced)

1. Install Node.js (if not installed):
   - Download from https://nodejs.org

2. Install Vercel CLI:
```powershell
npm install -g vercel
```

3. Login to Vercel:
```powershell
vercel login
```

4. Deploy from your project directory:
```powershell
cd "C:\Desktop\finance app"
vercel
```

5. Follow the prompts:
   - Set up and deploy? **Y**
   - Which scope? **Your account**
   - Link to existing project? **N**
   - Project name? **7k-money** (or your choice)
   - In which directory? **./web**
   - Want to override settings? **N**

6. Your site is deployed! 🚀

### Step 3: Custom Domain (Optional)

1. Go to your project in Vercel Dashboard

2. Click "Settings" → "Domains"

3. Add your domain:
   - If you have a domain: Enter it and follow DNS instructions
   - Use Vercel's free domain: `your-project.vercel.app`

## 🔧 Configuration Files

The following files have been created for you:

### `vercel.json`
- Configures routing and headers
- Sets up caching for better performance
- Routes root to landing page

### `.vercelignore`
- Excludes unnecessary files from deployment
- Keeps deployment fast and clean

### `index.html`
- Root redirect page
- Ensures landing page loads from root URL

## 📊 Post-Deployment

### Update Download Link

Once deployed, update the APK download link in your landing page:

1. Upload `app-release.apk` to your repository
2. Update the download link to:
   ```
   https://github.com/YOUR_USERNAME/7k-money-landing/raw/main/build/app/outputs/flutter-apk/app-release.apk
   ```

Or use a file hosting service like:
- Google Drive
- Dropbox
- GitHub Releases

### Environment URLs

After deployment, you'll have:
- **Production**: https://your-project.vercel.app
- **Preview**: https://your-project-git-branch.vercel.app (for each branch)

### Update README

Update the README.md file with your actual Vercel URL.

## 🎯 Verification Checklist

After deployment, verify:

- [ ] Landing page loads correctly
- [ ] All images display (logo, icons)
- [ ] All sections are visible (Hero, Features, Showcase, etc.)
- [ ] Buttons and links work
- [ ] Mobile responsive design works
- [ ] No console errors in browser DevTools
- [ ] Download link works (if APK is hosted)

## 🔄 Continuous Deployment

Vercel automatically deploys when you push to GitHub:

1. Make changes to your code
2. Commit and push:
```powershell
git add .
git commit -m "Update landing page"
git push
```
3. Vercel automatically builds and deploys! 🎉

## 🐛 Troubleshooting

### Issue: 404 Error
**Solution**: Check `vercel.json` routing configuration

### Issue: Images not loading
**Solution**: Verify all image paths are relative to `web/` directory

### Issue: CSS not applying
**Solution**: Check browser console for errors, verify CSS file path

### Issue: Build fails
**Solution**: Ensure all files are committed to Git repository

## 📞 Support

- Vercel Documentation: https://vercel.com/docs
- Vercel Support: https://vercel.com/support

## 🎊 Next Steps

1. Share your live URL on social media
2. Add analytics (Vercel Analytics is free!)
3. Set up a custom domain
4. Configure SEO meta tags
5. Add Google Analytics or similar

---

**Congratulations!** 🎉 Your 7K Money landing page is now live on the internet!

Your URL will be something like: `https://7k-money.vercel.app`
