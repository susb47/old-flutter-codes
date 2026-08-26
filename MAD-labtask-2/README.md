# Flutter ID Card App

This is a simple Flutter application that displays an ID card with user details.

## Features
- Displays user name, ID, semester, and email.
- Shows a profile picture.
- Uses a clean and modern UI design.

## Screenshot
![ID Card Screenshot](lib/lib/assets/images.jfif)

## Installation
1. Clone this repository:
   ```sh
   [git clone https://github.com/susb47/susmoy-MAD-labtask-2.git](https://github.com/susb47/susmoy-MAD-labtask-2.git)
   ```
2. Navigate to the project directory:
   ```sh
   cd flutter-id-card
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```
4. Run the app:
   ```sh
   flutter run
   ```

## Project Structure
```
flutter-id-card/
│── lib/
│   ├── main.dart  # Main application file
│── assets/
│   ├── profile_picture.png  # Profile image used in the card
│── pubspec.yaml  # Flutter configuration file
```

## Dependencies
- Flutter SDK

## Adding Profile Picture
Ensure you place your profile picture inside the `assets/` folder and declare it in `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/profile_picture.png
```

## License
This project is open-source and available under the MIT License.

---
Made with ❤️ using Flutter!

