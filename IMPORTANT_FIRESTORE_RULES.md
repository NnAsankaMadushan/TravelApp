# 🚨 CRITICAL: Update Firestore Rules NOW!

## You're Getting Permission Denied Errors!

Your app cannot work until you update the Firestore security rules.

### Quick Fix (2 minutes):

## Step 1: Go to Firebase Console
👉 [https://console.firebase.google.com/](https://console.firebase.google.com/)

## Step 2: Select Your Project
- Click on **travelapp-1a276**

## Step 3: Update Firestore Rules
1. Click **Firestore Database** (left sidebar)
2. Click **Rules** tab (top)
3. **Delete everything** and paste this:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow authenticated users to read and write their own user document
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }

    // Allow authenticated users to read all posts
    match /posts/{postId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && request.auth.uid == request.resource.data.userId;
      allow update, delete: if request.auth != null && request.auth.uid == resource.data.userId;

      // Comments subcollection
      match /comments/{commentId} {
        allow read: if request.auth != null;
        allow create: if request.auth != null;
        allow delete: if request.auth != null && request.auth.uid == resource.data.userId;
      }
    }
  }
}
```

4. Click **Publish** button

## Step 4: Hot Restart Your App
```bash
Press 'R' in terminal, or stop and run:
flutter run
```

## What These Rules Do:

✅ **Users can:**
- Read any user profile
- Only update their own profile

✅ **Posts:**
- Read all posts
- Create posts (as themselves)
- Only update/delete their own posts

✅ **Comments:**
- Read all comments
- Create comments
- Only delete their own comments

---

## After Updating Rules:

Your app will work! You'll be able to:
- ✅ View your profile
- ✅ Edit profile & upload photo
- ✅ Create posts
- ✅ Search users
- ✅ Add friends
- ✅ Comment & like posts

## New Feature Added:

**Profile Editing** 🎉
- Click the edit icon (✏️) in your profile
- Update username and bio
- Upload a new profile photo
- Changes save to Cloudinary & Firestore

---

**Don't forget to also set up Cloudinary!** See [CLOUDINARY_SETUP.md](CLOUDINARY_SETUP.md)
