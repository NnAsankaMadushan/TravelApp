# Firebase Configuration Fix

## What Was Fixed

The app was failing to start because of a package name mismatch between your Android app and Firebase configuration.

### Changes Made:

1. **Updated Android Package Name**
   - Changed from: `com.example.travel_app`
   - Changed to: `com.asanka.travel`
   - Files updated:
     - `android/app/build.gradle.kts` (namespace and applicationId)

2. **Moved MainActivity**
   - Old location: `android/app/src/main/kotlin/com/example/travel_app/MainActivity.kt`
   - New location: `android/app/src/main/kotlin/com/asanka/travel/MainActivity.kt`
   - Updated package declaration to: `package com.asanka.travel`

3. **Added Google Services Plugin**
   - Updated `android/build.gradle.kts` to include Google Services classpath
   - Updated `android/app/build.gradle.kts` to apply the Google Services plugin

## Next Steps

### 1. Stop the Currently Running App
Close the app if it's still running on the emulator/device.

### 2. Rebuild and Run
```bash
flutter run
```

The app should now start successfully!

### 3. Before You Can Use the App Features

You need to enable Firebase services in your Firebase Console:

#### Enable Authentication
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `travelapp-1a276`
3. Go to **Authentication** → **Sign-in method**
4. Enable **Email/Password** authentication
5. Click **Save**

#### Create Firestore Database
1. In Firebase Console, go to **Firestore Database**
2. Click **Create database**
3. Choose **Start in production mode** (we'll update rules)
4. Select a location (choose closest to your users)
5. Click **Enable**
6. Go to **Rules** tab and update to:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```
7. Click **Publish**

#### Enable Firebase Storage
1. In Firebase Console, go to **Storage**
2. Click **Get started**
3. Use default security rules
4. Choose same location as Firestore
5. Click **Done**
6. Go to **Rules** tab and update to:
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```
7. Click **Publish**

## Testing the App

### 1. Create an Account
- Open the app
- Click **Sign Up**
- Enter username, email, and password
- Click **Sign Up** button

### 2. Explore Features
- **Feed Tab**: View posts from friends (empty at first)
- **Map Tab**: See all posts on a map (requires location permission)
- **Search Tab**: Search for other users to add as friends
- **Profile Tab**: View your profile and posts

### 3. Create Your First Post
- Tap the **+** icon on the Feed screen
- Select photos from your gallery
- Add a caption
- Tap the location button to get current location (requires GPS permission)
- Tap **Post**

## Troubleshooting

### Issue: "Location permissions denied"
**Solution**: Grant location permissions when prompted, or go to app settings and enable location access.

### Issue: "Failed to pick images"
**Solution**: Grant storage/photos permissions when prompted.

### Issue: Map not showing
**Solution**: You need to set up Google Maps API key (see SETUP_GUIDE.md for details).

### Issue: Still getting Firebase errors
**Solution**:
1. Make sure you've enabled Authentication, Firestore, and Storage in Firebase Console
2. Stop the app completely
3. Run: `flutter clean`
4. Run: `flutter pub get`
5. Run: `flutter run`

## Important Notes

- The app requires an internet connection to work
- Location permissions are required for posting and map features
- Camera/Storage permissions are required for adding photos
- Make sure Firebase services (Auth, Firestore, Storage) are enabled before testing

## Your Firebase Project Details

- **Project ID**: `travelapp-1a276`
- **Package Name**: `com.asanka.travel`
- **Configuration File**: `android/app/google-services.json` ✅ Already configured
