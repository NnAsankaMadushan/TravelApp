# TravelApp - Complete Setup Guide

A Flutter-based travel social media app with Instagram-like features and map integration for sharing travel experiences.

## Features

- **User Authentication**: Sign up and login with Firebase Authentication
- **Feed View**: Instagram-style feed showing posts from friends
- **Map View**: Interactive map showing all posts as location markers/flags
- **Post Creation**: Create posts with multiple images and location tagging
- **Social Features**: Add friends, send/accept friend requests
- **Comments & Reactions**: Like posts and add comments
- **Profile Management**: View user profiles and post history
- **Search**: Find and connect with other users

## Tech Stack

- **Flutter**: Cross-platform mobile framework
- **Firebase**:
  - Authentication for user management
  - Firestore for data storage
  - Storage for image uploads
- **Google Maps**: Location visualization
- **Provider**: State management

## Setup Instructions

### Prerequisites

1. Flutter SDK installed (version 3.9.2 or higher)
2. Firebase project created
3. Google Maps API key (for Android and iOS)

### Firebase Setup

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)

2. Add Android app:
   - Package name: `com.example.travel_app` (or your custom package)
   - Download `google-services.json`
   - Place it in `android/app/`

3. Add iOS app:
   - Bundle ID: `com.example.travelApp` (or your custom bundle)
   - Download `GoogleService-Info.plist`
   - Place it in `ios/Runner/`

4. Enable Authentication:
   - Go to Firebase Console > Authentication
   - Enable Email/Password sign-in method

5. Create Firestore Database:
   - Go to Firebase Console > Firestore Database
   - Create database in production mode
   - Set up security rules (for development):
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

6. Enable Firebase Storage:
   - Go to Firebase Console > Storage
   - Get started with default settings
   - Update security rules (for development):
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

### Google Maps Setup

#### Android

1. Get a Google Maps API key from [Google Cloud Console](https://console.cloud.google.com/)
2. Enable "Maps SDK for Android"
3. Add the API key to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <application>
       <meta-data
           android:name="com.google.android.geo.API_KEY"
           android:value="YOUR_API_KEY_HERE"/>
   </application>
   ```

#### iOS

1. Enable "Maps SDK for iOS" in Google Cloud Console
2. Add the API key to `ios/Runner/AppDelegate.swift`:
   ```swift
   import GoogleMaps

   GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
   ```

3. Update `ios/Podfile` to set minimum iOS version to 13.0:
   ```ruby
   platform :ios, '13.0'
   ```

### Installation

1. Navigate to the project directory:
   ```bash
   cd travel_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── models/           # Data models (User, Post, Comment, Location)
├── providers/        # State management providers
├── screens/          # UI screens
│   ├── auth/        # Login and signup screens
│   ├── feed/        # Feed screen
│   ├── home/        # Main navigation
│   ├── map/         # Map view screen
│   ├── post/        # Post creation and detail
│   ├── profile/     # Profile screens
│   └── search/      # User search
├── services/         # Backend services (Auth, Firestore, Storage)
├── widgets/          # Reusable widgets
└── main.dart        # App entry point
```

## Key Features Explained

### Map View
- Shows all posts as markers on a Google Map
- Click on markers to preview posts
- Users can see posts from all users or filter by friends
- Each marker represents a travel location

### Create Post
- Select multiple images from gallery
- Add caption
- Tag current location (GPS-based)
- Location is mandatory for posting

### Feed
- Instagram-style scrollable feed
- Shows posts from friends
- Like and comment on posts
- Click on location to view on map

### Social Features
- Search for users by username
- Send friend requests
- Accept/reject friend requests
- View friend lists
- Remove friends

## Notes

- Make sure to set up Firebase configuration files before running
- Location permissions are required for posting and map features
- Internet connection is required for all features
- Images are stored in Firebase Storage

## Troubleshooting

### Firebase not initializing
- Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are in the correct locations
- Run `flutter clean` and `flutter pub get`

### Map not showing
- Check if Google Maps API key is correctly added
- Verify API is enabled in Google Cloud Console
- Check location permissions are granted

### Images not uploading
- Verify Firebase Storage is enabled
- Check storage security rules
- Ensure proper permissions for camera and gallery

## License

This project is created for educational purposes.
