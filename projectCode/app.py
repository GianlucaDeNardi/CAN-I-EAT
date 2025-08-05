import cv2
import face_recognition
import numpy as np
from flask import Flask, request, jsonify
from werkzeug.security import generate_password_hash, check_password_hash
from google.cloud import firestore

# Inizializza Firestore
db = firestore.Client()

app = Flask(__name__)

# Funzione per salvare un nuovo utente in Firestore
def save_user(email, username, hashed_password, face_encoding):
    # Crea un nuovo documento nella collezione 'users'
    doc_ref = db.collection('users').document()
    doc_ref.set({
        'email': email,
        'username': username,
        'password': hashed_password,
        'face_encoding': face_encoding.tolist()  # Salva l'encoding facciale come lista
    })
    return doc_ref.id

# Funzione per ottenere tutti gli utenti da Firestore
def get_all_user_images():
    users_ref = db.collection('users')
    docs = users_ref.stream()

    user_images = []
    for doc in docs:
        user_data = doc.to_dict()
        user_images.append({
            'user_id': doc.id,
            'email': user_data['email'],
            'username': user_data['username'],
            'face_encoding': user_data['face_encoding'],
        })
    return user_images

# API di registrazione
@app.route('/register', methods=['POST'])
def register():
    # Dati dell'utente
    email = request.form['email']
    username = request.form['username']
    password = request.form['password']
    
    # Hash della password
    hashed_password = generate_password_hash(password, method='pbkdf2:sha256')

    # Immagine facciale per il riconoscimento
    file = request.files['image'].read()
    npimg = np.frombuffer(file, np.uint8)
    frame = cv2.imdecode(npimg, cv2.IMREAD_COLOR)

    # Encoding del volto
    face_encoding = face_recognition.face_encodings(frame)
    
    if len(face_encoding) == 0:
        return jsonify({'error': 'No face detected'}), 400

    # Salva i dati dell'utente nel database
    user_id = save_user(email, username, hashed_password, face_encoding[0])

    return jsonify({'message': 'User registered successfully', 'user_id': user_id}), 201

# API di login tramite riconoscimento facciale
@app.route('/login_face', methods=['POST'])
def login_face():
    # Riceve l'immagine dal client
    file = request.files['image'].read()
    npimg = np.frombuffer(file, np.uint8)
    frame = cv2.imdecode(npimg, cv2.IMREAD_COLOR)

    # Trova i volti nel frame corrente
    face_encodings = face_recognition.face_encodings(frame)
    
    if len(face_encodings) == 0:
        return jsonify({'error': 'No face detected'}), 400
    
    # Confronta l'encoding del volto con quelli registrati nel database
    user_images = get_all_user_images()  
    for user_image in user_images:
        matches = face_recognition.compare_faces([user_image['face_encoding']], face_encodings[0])
        if any(matches):
            # Se c'è un match, ritorna il login con successo
            return jsonify({'message': 'Login successful', 'user_id': user_image['user_id']}), 200
    
    return jsonify({'error': 'Face not recognized'}), 401

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
