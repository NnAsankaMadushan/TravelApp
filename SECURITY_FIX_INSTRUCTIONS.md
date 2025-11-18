# Security Fix Instructions - API Key Exposure

## URGENT: API Key Revocation Required

GitGuardian has detected an exposed Google API Key in your GitHub repository. Follow these steps immediately:

## Step 1: Revoke the Exposed API Key (DO THIS FIRST!)

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Select your project: `travelapp-1a276`
3. Navigate to **APIs & Services** > **Credentials**
4. Find the API key: `AIzaSyCAk_Jv-hDFkL6FXCRjuX4vffdPUxaIMiE`
5. Click the **DELETE** or **REVOKE** button
6. Confirm the deletion

## Step 2: Generate New API Keys with Restrictions

### For Firebase (Android & iOS):
1. In Google Cloud Console > **APIs & Services** > **Credentials**
2. Click **+ CREATE CREDENTIALS** > **API key**
3. Click **RESTRICT KEY**
4. Under "Application restrictions":
   - For Android: Select "Android apps" and add your package name
   - For iOS: Select "iOS apps" and add your bundle ID
5. Under "API restrictions":
   - Select "Restrict key"
   - Enable only the Firebase APIs you need
6. Save the key

### For Google Maps:
1. Create a separate API key for Google Maps
2. Under "Application restrictions":
   - For Android: Add package name and SHA-1 certificate fingerprint
   - For iOS: Add bundle ID
3. Under "API restrictions":
   - Enable only: Maps SDK for Android, Maps SDK for iOS, Places API
4. Save the key

## Step 3: Configure Local Environment

1. Copy `.env.example` to `.env`:
   \`\`\`bash
   cp .env.example .env
   \`\`\`

2. Edit `.env` and add your new API keys:
   \`\`\`
   FIREBASE_ANDROID_API_KEY=your_new_firebase_android_key
   FIREBASE_IOS_API_KEY=your_new_firebase_ios_key
   GOOGLE_MAPS_API_KEY=your_new_google_maps_key
   \`\`\`

3. Copy `lib/config/api_keys.dart.example` to `lib/config/api_keys.dart`:
   \`\`\`bash
   cp lib/config/api_keys.dart.example lib/config/api_keys.dart
   \`\`\`

4. Edit `lib/config/api_keys.dart` and add your new API keys

## Step 4: Update Your Code

1. Update `lib/firebase_options.dart` to use the new ApiKeys class
2. Update `android/app/src/main/AndroidManifest.xml` to use the new Google Maps key
3. Test your app to ensure everything works with the new keys

## Step 5: Remove Sensitive Files from Git History

**WARNING**: This will rewrite Git history. Coordinate with your team first!

\`\`\`bash
# Install git-filter-repo if not already installed
# pip install git-filter-repo

# Remove the exposed key from all commits
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch lib/firebase_options.dart android/app/src/main/AndroidManifest.xml" \
  --prune-empty --tag-name-filter cat -- --all

# Force push to remote (only if you're sure!)
# git push origin --force --all
\`\`\`

## Step 6: Verify Security

1. Check that `.env` and `lib/config/api_keys.dart` are in `.gitignore`
2. Run: `git status` - ensure no sensitive files are staged
3. Commit the changes:
   \`\`\`bash
   git add .gitignore .env.example lib/config/api_keys.dart.example SECURITY_FIX_INSTRUCTIONS.md
   git commit -m "security: Add API key management and .gitignore rules"
   \`\`\`

## Prevention Tips

- ✅ Always use environment variables or config files for API keys
- ✅ Add sensitive files to `.gitignore` BEFORE committing
- ✅ Use API key restrictions in Google Cloud Console
- ✅ Regularly rotate API keys
- ✅ Enable GitGuardian or similar tools for your repositories
- ❌ Never hardcode API keys in source code
- ❌ Never commit `.env` files or config files with real keys

## Additional Resources

- [Google Cloud API Key Best Practices](https://cloud.google.com/docs/authentication/api-keys)
- [GitGuardian Documentation](https://docs.gitguardian.com/)
- [Firebase Security Rules](https://firebase.google.com/docs/rules)
