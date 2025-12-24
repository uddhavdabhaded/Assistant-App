# AI Assistant App

A beautiful Flutter-based AI Assistant application with an elegant UI and smooth animations.

## 📁 Folder Structure

```
assistant_app/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── constants/                   # App-wide constants
│   │   ├── app_colors.dart         # Color palette and gradients
│   │   └── app_strings.dart        # Text constants
│   ├── screens/                     # App screens
│   │   ├── splash_screen.dart      # Animated splash screen
│   │   └── assistant_screen.dart   # Main assistant interface
│   ├── widgets/                     # Reusable widgets (for future use)
│   └── utils/                       # Utility functions (for future use)
├── assets/
│   └── images/                      # Image assets
│       ├── app_logo.png            # App logo
│       └── robot_assistant.png     # Robot assistant image
└── pubspec.yaml                     # Dependencies and assets
```

## ✨ Features

### 🎨 Splash Screen
- **Animated Logo**: Smooth fade-in and scale animation
- **Gradient Background**: Beautiful purple-to-cyan gradient
- **Loading Indicator**: Elegant circular progress indicator
- **Auto Navigation**: Automatically transitions to assistant screen after 3 seconds

### 🤖 Assistant Screen
- **Robot Character**: Friendly animated robot assistant
- **Greeting Card**: Clean, modern card with welcome message
- **Microphone Button**: 
  - Pulsing animation when listening
  - Gradient background with glow effect
  - Toggle between listening and idle states
- **Wave Indicators**: Animated sound wave bars when listening
- **Responsive Design**: Adapts to different screen sizes

## 🎨 Design Features

- **Modern Gradient Theme**: Purple (#8B5CF6) to Cyan (#06B6D4)
- **Google Fonts**: Using Poppins font for premium typography
- **Smooth Animations**: 
  - Fade transitions
  - Scale animations
  - Pulse effects
  - Floating animations
- **Glassmorphism Effects**: Subtle shadows and blur effects
- **Responsive Layout**: Works on all screen sizes

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK

### Installation

1. Clone the repository
2. Navigate to the project directory:
   ```bash
   cd assistant_app
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## 📦 Dependencies

- **google_fonts**: ^6.1.0 - For beautiful typography
- **cupertino_icons**: ^1.0.8 - iOS-style icons

## 🎯 Future Enhancements

- [ ] Integrate speech recognition
- [ ] Add voice response functionality
- [ ] Implement AI/ML backend integration
- [ ] Add chat history
- [ ] Support multiple languages
- [ ] Add settings screen
- [ ] Implement dark mode

## 🎨 Color Palette

| Color | Hex Code | Usage |
|-------|----------|-------|
| Primary Purple | #8B5CF6 | Primary gradient start |
| Primary Cyan | #06B6D4 | Primary gradient end |
| Deep Purple | #6D28D9 | Accent color |
| Background | #F8F9FE | Main background |
| Text Primary | #1F2937 | Main text |
| Text Secondary | #6B7280 | Secondary text |

## 📱 Screenshots

The app features:
1. **Splash Screen**: Animated logo with gradient background
2. **Assistant Screen**: Robot character with microphone interaction

## 🛠️ Built With

- **Flutter** - UI framework
- **Material Design 3** - Design system
- **Google Fonts** - Typography

## 📄 License

This project is created for educational purposes.

---

Made with ❤️ using Flutter
