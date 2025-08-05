import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'main.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  File? _image;
  final picker = ImagePicker();
  bool _imageCaptured = false;

  // Funzione per catturare l'immagine dalla fotocamera
  Future<void> _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageCaptured = true;
      });
      _showConfirmationDialog();
    } else {
      setState(() {
        _imageCaptured = false;
      });
    }
  }

  // Funzione per confermare i dati inseriti
  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confermi i tuoi dati?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                if (_image != null)
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: FileImage(_image!),
                  ),
                SizedBox(height: 20),
                Text('Email: ${_emailController.text}'),
                Text('Username: ${_usernameController.text}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Si'),
              onPressed: () {
                Navigator.of(context).pop();
                _register();
              },
            ),
          ],
        );
      },
    );
  }

  // Funzione di registrazione
  Future<void> _register() async {
    if (_image != null) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://34.46.113.138:5000/register'),
      );
      request.fields['email'] = _emailController.text;
      request.fields['username'] = _usernameController.text;
      request.fields['password'] = _passwordController.text;
      request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

      var response = await request.send();

      if (response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SplashPage()),
        );
      } else {
        print("Error during registration");
      }
    } else {
      print("Please capture an image before registering.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange.shade200, Colors.orange.shade400],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/logo.png',  // Assicurati che il percorso sia corretto
                  height: 120,
                ),
                SizedBox(height: 40),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Face-Print",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _getImage,
                      child: Icon(Icons.camera_alt, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _imageCaptured ? Colors.green : Colors.white,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(15),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_image != null) {
                        _register();
                      } else {
                        print('Please capture an image before registering.');
                      }
                    },
                    child: Text('Register'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
