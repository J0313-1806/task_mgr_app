# Flutter Task Manager App

A Flutter application for managing tasks with advanced features like search, drag-and-drop, bulk deletion, and smart blocking/unblocking of dependent tasks. The app uses **GetX** for state management and connects to a backend repository (link to be provided).

---

## 🚀 Setup Instructions

### Prerequisites
- Install [Flutter](https://docs.flutter.dev/get-started/install) (latest stable version).
- Install Android Studio or VS Code with Flutter/Dart plugins.
- Ensure you have an Android device/emulator with USB debugging enabled.

### Step-by-Step Setup
1. **Clone the repository**
   ```bash
   git clone https://github.com/J0313-1806/task_mgr_app
   cd <project-folder>
   ```
2.
```bash
 flutter pub get
```
3.
```bash
 Connect backend
    Update the API base URL in your app’s configuration to point to the [(backend repo)](https://github.com/J0313-1806/task_mgr_api).
    Ensure the backend server is running.
```
4.
```bash
 flutter run
```
5.
```bash
 flutter build apk --release
 adb install -r build/app/outputs/flutter-apk/app-release.apk
```


**✨ Features**

    Search functionality
        Search tasks by title, description, or due date.

    Drag-and-drop cards
        Reorder tasks easily by dragging cards within the grid.

    Bulk delete
        Double-tap to select multiple cards and delete them in one action.

    CRUD operations
        Create, Read, Update, and Delete tasks with a simple UI.

    Blocking logic
        If a task is blocked by another, it cannot be completed until the blocking task is marked as Done.
        Once the blocking task is completed, dependent tasks automatically become available.

    State management
        Built with GetX for reactive, efficient, and clean state handling.



**🛠️ Tech Stack**

    Frontend: Flutter (Dart)

    State Management: GetX
```bash
    Backend: FastAPI [(Backend Repo)] (https://github.com/J0313-1806/task_mgr_api)
```
    Database: PostgresSQL



**📱 Usage**

    Launch the app on your device.

    Add tasks with title, description, due date, and optional blocking relationships.

    Use the search bar to filter tasks.

    Drag cards to reorder tasks visually.

    Double-tap cards to select multiple and delete in bulk.

    Complete tasks; blocked tasks will automatically unlock when their blockers are done.
