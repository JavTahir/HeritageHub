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

### 7. Firebase Integration
- Data persistence using Firestore
- Phone authentication setup - enable phone auth provider
- **Setup Instructions**:
  In your project directory:
  ```bash
  cd android
  ./gradlew signingReport  # Get SHA256 key for Firebase config which will verify your device
  ```
  
