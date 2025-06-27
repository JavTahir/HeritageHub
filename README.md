# Heritage Hub - Family Tree Management System

Heritage Hub is a comprehensive family tree management application that helps users maintain and visualize their family connections. It provides features for family member registration, relationship mapping, visual family tree generation, and temple associations based on community (Samaj).

## Directory Structure

```plaintext
lib/
├── core/
│   ├── constants/     # App constants, themes, and configurations
│   ├── services/      # Core services (Firebase, Cloudinary, etc.)
│   ├── utils/         # Utility functions and helpers
│   └── widgets/       # Reusable custom widgets
├── features/          # Feature-specific screens and components
├── models/            # Data models and DTOs
├── providers/         # State management providers
└── main.dart          # Application entry point

android/               # Android-specific configurations
ios/                   # iOS-specific configurations
pubspec.yaml           # Flutter dependencies and metadata
```



## Core Features

### 1. OTP-based Phone Authentication
- **Testing Configuration**:
  - Selected Country: Pakistan (+92)
  - Head Testing Number: `+923165501493`
  - Member Testing Number: `+921234567898`
  - OTP for both: `123456`
  #### Important Note About Test Numbers
These specific numbers are configured for **development purposes only** because:

  1. **Firebase Phone Auth Requirements**:
     - Production usage requires a [paid billing account](https://firebase.google.com/docs/auth/android/phone-auth#enable-phone-authentication)
     - Without billing, only whitelisted test numbers work
  
  2. **Cost Considerations**:
     - Real phone authentication incurs SMS charges
     - Test numbers avoid unnecessary costs during development
  
  3. **How to Use Real Numbers**:
     ```bash
     # If you have billing enabled:
     1. Go to Firebase Console > Authentication
     2. Enable "Phone" authentication provider
     3. Remove test numbers from whitelist
     4. The app will then work with any Pakistani (+92) number



### 2. Auto-linking of Family Members
- Automatic connection of members to Head via relationship mapping
- Phone number-based association

### 3. Visual Family Tree
- Interactive tree visualization of family relationships
- Hierarchical display of generations

### 4. Export Tree
- PDF generation of family tree
- Shareable export functionality

### 5. Temples Auto-Association
- Automatic temple suggestions based on user's Samaj
- Community-specific temple listings

### 6. Edit Permissions
- Role-based access control
- Only Head can delete family member details

### 7. Comprehensive Form Validation
- Validates all required fields before submission
- Checks for proper phone number formats
- Ensures email validity when provided
- Validates date formats and logical age ranges
- Relationship verification between family members

### 8. Post-submission Overview
- Summary of entered information
- Quick access to newly added members

### 9. Profile Photo Preview
- Tap-to-view fullscreen profile photos
- Hero animations for smooth transitions

### 10. Cloudinary Integration  
`As Firebase Storage requires Billing`
- Add in core/services/cloudinary_services.dart, your cloudinary credentials


## Usage

### 1. Firebase Integration
- Data persistence using Firestore
- Phone authentication setup - enable phone auth provider
- **Setup Instructions**:
  In your project directory:
  ```bash
  cd android
  ./gradlew signingReport  # Get SHA256 key for Firebase config which will verify your device.Add it in SHA-FingerPrint field in settings in Project Android App
  ```

### 2. Installation
Clone repo:
  ```bash
 git clone [https://github.com/your-repo/heritage-hub.git](https://github.com/JavTahir/HeritageHub.git)
 cd heritage-hub
  ```

Install dependencies:
  ```bash
flutter pub get
  ```

Create splash screen:
  ```bash
 dart run flutter_native_splash:create --path=native_splash.yaml
  ```

Run Project:
  ```bash
flutter run  #Ignore if you see any compilesdk errors it wont effect the build
  ```


### 3. Temples Collection Configuration

For the temple association feature to work, you need to create a `temples` collection in Firestore with the following structure:

```javascript
// Collection: temples
// Document: auto-ID 
{
  contactNumber: "+919876543210",  // string
  description: "Main Swaminarayan temple in Gujarat",  // string
  imageUrl: "https://example.com/temple1.jpg",  // string
  location: "Ahmedabad, Gujarat",  // string
  name: "Shree Swaminarayan Temple",  // string
  samaj: "Swaminarayan"  // string (must match Samaj names in your app)
}
```


Good Job! You are ready to o now.Feel free to contribute in this project and share more valuabe features to add

## Project Demo
[![Heritage Hub Demo Video](https://drive.google.com/thumbnail?id=1LFD9Z5tgqAppt6ZeF0wkjqrx5K_HNUXb)](https://drive.google.com/file/d/1LFD9Z5tgqAppt6ZeF0wkjqrx5K_HNUXb/view?usp=sharing)

Click the thumbnail above to watch the full demo video

