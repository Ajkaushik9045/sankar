# Taskly - Production Task Manager

Taskly is a production-grade Task Management application built with Flutter, focusing on **Clean Architecture**, **Real-time Synchronization**, and **Modern UI/UX**. It leverages Firebase for authentication and data persistence, providing a seamless experience across devices.

## 🚀 Features

- **User Authentication**: Secure Sign Up and Login using Firebase Auth.
- **Real-time Tasks**: Live synchronization of tasks across devices using Cloud Firestore.
- **Task CRUD**: Create, Read, Update, and Delete tasks with ease.
- **Task Status**: Track progress with statuses (To Do, In Progress, Completed).
- **Motivational Quotes**: Daily inspiration fetched from a REST API (Quotable).
- **Responsive Design**: Pixel-perfect layout across all screen sizes using `flutter_screenutil`.
- **Modern UI**: Material 3 design with a premium indigo/blue aesthetic.
- **Error Handling**: Centralized failure management and robust state updates.

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **Language**: [Dart](https://dart.dev/)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc) (Cubit)
- **Navigation**: [go_router](https://pub.dev/packages/go_router)
- **Database**: [Cloud Firestore](https://firebase.google.com/docs/firestore)
- **Auth**: [Firebase Authentication](https://firebase.google.com/docs/auth)
- **Networking**: [Dio](https://pub.dev/packages/dio)
- **Theming**: [Google Fonts](https://pub.dev/packages/google_fonts) (Outfit)
- **Responsive UI**: [flutter_screenutil](https://pub.dev/packages/flutter_screenutil)

## 🏗 Architecture

The project follows a **Feature-first Clean Architecture** approach, ensuring scalability and maintainability:

```
lib/
├── core/               # App-wide utilities, theme, and navigation
│   ├── error/          # Failure classes
│   ├── navigation/     # GoRouter configuration
│   ├── network/        # Dio client wrapper
│   └── theme/          # Material 3 theme and colors
├── features/           # Feature-specific modules
│   ├── auth/           # Login & Sign Up logic
│   ├── tasks/          # Task CRUD & Real-time sync
│   └── quotes/         # API integration for motivational quotes
├── shared/             # Reusable UI components (buttons, textfields)
└── main.dart           # App entry point & dependency injection
```

## 🏁 Getting Started

### Prerequisites

- Flutter SDK (Latest Version)
- Firebase Account
- Android Studio / VS Code

### Setup Instructions

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/taskly.git
   cd taskly
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration**:
   - Create a new project on [Firebase Console](https://console.firebase.google.com/).
   - Enable **Email/Password** Authentication.
   - Create a **Firestore Database** in test mode (or apply the rules in the next step).
   - Add an Android app with package name `com.example.sankar`.
   - Download `google-services.json` and place it in `android/app/`.

4. **Firestore Security Rules**:
   Apply the following rules in your Firebase Console:
   ```javascript
   service cloud.firestore {
     match /databases/{database}/documents {
       match /tasks/{taskId} {
         allow read, write, delete: if request.auth != null && (resource == null || resource.data.uid == request.auth.uid) && (request.resource == null || request.resource.data.uid == request.auth.uid);
       }
     }
   }
   ```

5. **Run the app**:
   ```bash
   flutter run
   ```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements.
