# 🧠 Face Recognition Log-In System with Cybersecurity Focus

This project implements a **face recognition-based login system** for an Android mobile application, with a strong emphasis on **user data protection** and **cloud-based cybersecurity**. The system combines **facial biometrics**, **secure authentication**, and **encrypted credential storage**, ensuring a modern and safe user experience.

## 📱 Project Overview

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

## 🧾 Conclusion

This project demonstrates how to implement a **secure, biometric authentication system** with cloud integration and modern encryption standards. While face recognition is often taken for granted in commercial apps, this system shows how such features can be recreated **from scratch**, securely and at zero cost.

---

## 👨‍🎓 Author

**Gianluca Giuseppe Maria De Nardi**  
Double Master's Graduate in AI & IoT Engineering  
University of Udine & University of Klagenfurt

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
