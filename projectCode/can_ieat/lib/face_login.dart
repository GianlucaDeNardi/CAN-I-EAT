import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'home_page.dart';
import 'login.dart';  // La pagina di login manuale

class FaceLoginPage extends StatefulWidget {
  @override
  _FaceLoginPageState createState() => _FaceLoginPageState();
}

class _FaceLoginPageState extends State<FaceLoginPage> {
  File? _image;
  final picker = ImagePicker();
  bool _isProcessing = false;

  // Funzione per catturare l'immagine dalla fotocamera
  Future<void> _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isProcessing = true;
      });
      _loginWithFace();
    }
  }

  // Funzione per inviare l'immagine al server per il riconoscimento facciale
  Future<void> _loginWithFace() async {
    if (_image != null) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://34.46.113.138:5000/login_face'),
      );
      request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      setState(() {
        _isProcessing = false;
      });

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getImage();  // Avvia la fotocamera non appena la pagina viene visualizzata
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade200,
        title: Text(
          "Face Recognition Login",
          style: TextStyle(
            fontFamily: 'SFPro',  // Imposta il font SFPro
            fontWeight: FontWeight.bold,  // Imposta il grassetto
            fontSize: 24,  // Imposta la dimensione del titolo
            color: Colors.black,  // Imposta il colore del titolo
          ),
        ),
        centerTitle: true,  // Centra il titolo
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange.shade200, Colors.orange.shade400],
          ),
        ),
        child: Center(
          child: _isProcessing
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Face detection on going',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'SFPro',  // Imposta il font SFPro
                  fontWeight: FontWeight.bold,  // Imposta il testo in grassetto
                  color: Colors.white,  // Colore del testo
                ),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(),  // Indicatore di caricamento
            ],
          )
              : Text(
            'No image selected.',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'SFPro',  // Imposta il font SFPro
              color: Colors.white,  // Colore del testo
            ),
          ),
        ),
      ),
    );
  }
}
