# 🧠 CAN I EAT – Mobile AI App Integration with Face Recognition Security System

This project integrates two core components into a cohesive mobile-first solution: a **secure face recognition log-in system** and a **real-time food recognition app** called *CAN I EAT*. Both modules are designed with a strong focus on **usability**, **privacy**, and **real-world applicability**, particularly in the field of health monitoring and secure user access. The App works on Androind and Apple.

The first part of the project focuses on **biometric authentication** using facial recognition as a primary method of user identification. This system ensures that only authorized users can access sensitive features of the app. It relies on a secure cloud infrastructure (Google Cloud VM + Firestore), modern encryption algorithms (PBKDF2 with SHA-256, bcrypt), and AI-based face encoding via `face_recognition`.

The second part, *CAN I EAT*, is an intelligent mobile app that allows users to **identify food items through their camera**, analyze possible **allergens**, and keep track of their food history. This system uses **Clarifai's food classification API** via a Dart backend and features a polished user interface developed in Android Studio.

By combining advanced computer vision models with practical mobile UX, this project demonstrates how AI can support both **personal security** and **healthy living**, through a unified and intuitive digital experience.


This project implements a **face recognition-based login system** for an Android mobile application, with a strong emphasis on **user data protection** and **cloud-based cybersecurity**. The system combines **facial biometrics**, **secure authentication**, and **encrypted credential storage**, ensuring a modern and safe user experience.


## 🧠 Face Recognition Log-In System with Cybersecurity Focus

### 📱 Project Overview

- Developed with **Android Studio** (Frontend) and **Python** (Backend).
- Backend hosted on a **secure Google Cloud VM**, accessible only by the owner via authenticated Google account login.
- User credentials and biometric encodings are stored in **Google Firestore** (NoSQL DB).

### 🔒 Key Features

- **Face Recognition Login** using `face_recognition`, `OpenCV`, and NumPy.
- **Fallback to traditional login** with username + password.
- Passwords are encrypted using `bcrypt` hashing (`werkzeug.security`).
- **PBKDF2 with SHA-256** ensures salted, slow-hashed passwords, resistant to brute-force attacks.
- Real-time camera image upload and facial encoding.
- Secure registration and login endpoints with `Flask`.

---

## 🛠️ Tech Stack

| Component       | Technology                         |
|----------------|-------------------------------------|
| Frontend App   | Android Studio (Java/Kotlin)       |
| Backend API    | Python (Flask)                     |
| Face Recognition | `face_recognition`, OpenCV       |
| Authentication | bcrypt, PBKDF2 + SHA-256           |
| Cloud Hosting  | Google Cloud VM (Linux)            |
| Database       | Google Firestore (NoSQL)           |

---

## 🚀 How it Works

### 🔐 Registration Flow

1. User submits:
   - Email, Username, Password
   - Facial image (via camera)
2. Password is hashed using PBKDF2 + SHA-256.
3. Face encoding is extracted with `face_recognition`.
4. Data is securely stored in Firestore.

### 👁️‍🗨️ Login Flow

1. User submits a facial image (or username + password).
2. The backend compares the face encoding with existing encodings in the DB.
3. If matched, login is successful. Otherwise, fallback to traditional login.

---

## 📦 Endpoints Overview

- `POST /register`: Registers a new user with email, password, and face.
- `POST /login_face`: Authenticates user via face recognition.
- `POST /login`: Traditional login with credentials.

---

## 🧪 Demo Screenshots

📷 First login prompts camera input  
✅ Success → app access granted  
❌ Failure → fallback to manual login form  
🗃️ New user appears in Firestore after registration

---

## 🍲 CAN I EAT – Mobile App Integration

This project is also integrated into the broader scope of **"CAN I EAT"**, a mobile application designed to assist users in identifying food items through AI-based visual recognition.

### 🧠 Android App UX Flow

- **Splash Screen**: Features the logo (food in a magnifying glass and speech bubble) in monochrome for a clean visual introduction.
- **Home Page**: A large circular button for instant access to the camera. Users can also access their gallery or detection history.
- **Permissions**: Camera, gallery, and internet access are required and managed via `AndroidManifest.xml`.
- **Camera Integration**: On capturing an image, it's sent to the AI model and results are displayed back in-app and saved.
- **Food Detection Screen**: Shows prediction above 55% confidence. Displays "Are you eating X?" and lets users accept (save to history) or retake.
- **Gallery Page**: Allows selecting an image from the gallery to run the detection pipeline.
- **History Page**: Lists past detections by date with editable entries and thumbnails.
- **Detail Page**: Displays food image, ingredients, and icons for any detected allergens (11 total). Designed like a table for clarity.
- **Profile Page**: Shows app creator’s name, email, and phone contact.

### 🔍 AI Model Integration

- **Model**: Uses **Clarifai’s community food-recognition model**
- **API Interaction**: Implemented in Dart (`food_recognition_service.dart`) using HTTP POST with a Clarifai API Key and Model ID.
- **Thresholding**: Only displays predictions above 55% confidence.
- **JSON Response Parsing**: Parses identified food items and confidence scores.

---

## 🧾 Extended Conclusion

This combined system merges facial recognition login with advanced food detection AI, all within a sleek, mobile-first experience. The app prioritizes **usability, privacy, and health awareness** by enabling:
- Secure biometric access
- Food allergen detection
- Full image history and detailed analysis

Future improvements include the development of a **custom-trained food detection model** for enhanced accuracy.

---

## 👨‍🎓 Author

**Gianluca Giuseppe Maria De Nardi**  
Double Master's Graduate in AI & IoT Engineering  
University of Udine & University of Klagenfurt

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
