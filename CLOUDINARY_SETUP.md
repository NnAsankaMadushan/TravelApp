# Cloudinary Setup Guide

Your app now uses **Cloudinary** for image storage instead of Firebase Storage. Cloudinary is a powerful media management platform that's easier to set up and offers better image optimization.

## Why Cloudinary?

- ✅ Free tier with 25GB storage & 25GB bandwidth
- ✅ Automatic image optimization
- ✅ No complex security rules needed
- ✅ Built-in image transformations (resize, crop, filters)
- ✅ CDN delivery for fast image loading

## Setup Steps

### 1. Create a Cloudinary Account

1. Go to [https://cloudinary.com/users/register/free](https://cloudinary.com/users/register/free)
2. Sign up for a **free account**
3. Verify your email

### 2. Get Your Credentials

1. After logging in, you'll see your **Dashboard**
2. Copy the following credentials:
   - **Cloud Name** (e.g., `dxyz123`)
   - **API Key** (you'll need this for upload preset)

### 3. Create an Upload Preset

Upload presets allow unsigned uploads from your mobile app.

1. In your Cloudinary dashboard, go to **Settings** (gear icon)
2. Click on **Upload** tab
3. Scroll down to **Upload presets**
4. Click **Add upload preset**
5. Configure the preset:
   - **Preset name**: `travel_app_posts` (or any name you prefer)
   - **Signing Mode**: Select **"Unsigned"** (IMPORTANT!)
   - **Folder**: `travel_app` (optional, keeps your uploads organized)
   - **Access mode**: `Public`
6. Click **Save**

### 4. Configure Your App

Open the file: `lib/utils/cloudinary_config.dart`

Replace the placeholders with your actual credentials:

```dart
class CloudinaryConfig {
  static const String cloudName = 'YOUR_CLOUD_NAME'; // e.g., 'dxyz123'
  static const String uploadPreset = 'YOUR_UPLOAD_PRESET'; // e.g., 'travel_app_posts'
}
```

**Example:**
```dart
class CloudinaryConfig {
  static const String cloudName = 'dxyz123';
  static const String uploadPreset = 'travel_app_posts';
}
```

### 5. Test Image Upload

1. Stop your app if it's running
2. Run: `flutter run`
3. Log in to your app
4. Try creating a post with images
5. Images should upload to your Cloudinary account!

## Verify Upload in Cloudinary

1. Go to [Cloudinary Console](https://console.cloudinary.com/)
2. Click on **Media Library**
3. You should see your uploaded images in the `travel_app` folder

## Features

### Automatic Image Optimization

Cloudinary automatically:
- Compresses images for faster loading
- Serves images in modern formats (WebP)
- Delivers via CDN for global performance

### Image Transformations (Optional)

You can add transformations to image URLs:

```dart
// Original
https://res.cloudinary.com/dxyz123/image/upload/v1234/post.jpg

// Resized to 500px width
https://res.cloudinary.com/dxyz123/image/upload/w_500/v1234/post.jpg

// Thumbnail 200x200
https://res.cloudinary.com/dxyz123/image/upload/w_200,h_200,c_fill/v1234/post.jpg
```

## Free Tier Limits

Cloudinary free tier includes:
- **25 GB** storage
- **25 GB** monthly bandwidth
- **25,000** transformations per month
- This is more than enough for a personal project or MVP!

## Troubleshooting

### Error: "Upload preset not found"
- Make sure you created an **unsigned** upload preset
- Check that the preset name matches exactly in your config

### Error: "Invalid cloud name"
- Verify your cloud name is correct (found in dashboard)
- Cloud name is case-sensitive

### Images not showing
- Check the image URLs in Firestore
- Make sure images are set to "Public" access mode
- Verify your upload preset has correct settings

## Comparison: Cloudinary vs Firebase Storage

| Feature | Cloudinary | Firebase Storage |
|---------|------------|------------------|
| Setup | Easy (no rules) | Complex (security rules) |
| Free Tier | 25GB storage | 5GB storage |
| Image Optimization | Automatic | Manual |
| CDN | Built-in | Need to configure |
| Transformations | Built-in | Not available |

## Next Steps

Once configured:
1. Update Firestore rules (see FIREBASE_FIX.md)
2. Test creating posts with images
3. Enjoy fast, optimized image uploads!

---

**Note:** Firebase Storage has been completely removed from the project. All image uploads now go through Cloudinary.
