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

- **Selected Country**: India `(+91)`
- **Head (Primary User) Testing Number**: `+91 9123456789`
- **Member (Family User) Testing Number**: `+91 7987654321`
- **Default OTP for Both**: `123456`



#### 🚀 How It Works

- When you launch the app for the first time, you’ll be prompted to **register as either a Head or a Member**.
- If registering as a **Head**, use the **test number `+91 9123456789`**. This number is already configured in the **Phone Authentication** section of my Firebase project for testing.
- After successful login and head registration, you can **add a family member**.
- While adding the member’s phone number during registration, use **`+91 7987654321`** (also pre-configured).
- Then, log in using this member number to **access the Member Dashboard**.


#### ⚠️ Important Note About Test Numbers

These numbers are configured only for **development and testing**. If you **do not have access** to my Firebase project:

- You won’t be able to use these numbers directly.
- Instead, go to your **Firebase Console → Authentication → Sign-in Method → Phone**, and **add your own test numbers** with a static OTP (e.g., `123456`) for local testing.



#### Firebase Phone Auth Requirements(For Production)
 - Production usage requires a [paid billing account](https://firebase.google.com/docs/auth/android/phone-auth#enable-phone-authentication)
 - Without billing, only whitelisted test numbers work(as described above)
  
  1. **Cost Considerations**:
     - Real phone authentication incurs SMS charges
     - Test numbers avoid unnecessary costs during development
  
  2. **How to Use Real Numbers**:
     ```bash
     # If you have billing enabled:
     1. Go to Firebase Console > Authentication
     2. Enable "Phone" authentication provider
     3. Remove test numbers from whitelist
     4. The app will then work with any number


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

For the temple association feature to work, you need to create a `temples` collection in Firestore with the following structure- you can also use any temples-data api
but for now i added them manually:

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

{
  contactNumber: "+919876543211",  // string
  description: "Ancient Brahmin temple",  // string
  imageUrl: "https://www.jangidbrahminsamaj.com/gallery/g75.jpg",  // string
  location: "Varanasi, UP",  // string
  name: "Brahmin Samaj Mandir",  // string
  samaj: "Brahmin"  // string (must match Samaj names in your app)
}
```

Good Job! You are ready to o now.Feel free to contribute in this project and share more valuabe features to add

## Project Demo
[![Heritage Hub Demo Video](https://drive.google.com/thumbnail?id=1LFD9Z5tgqAppt6ZeF0wkjqrx5K_HNUXb)](https://drive.google.com/file/d/1LFD9Z5tgqAppt6ZeF0wkjqrx5K_HNUXb/view?usp=sharing)

Click the thumbnail above to watch the full demo video

