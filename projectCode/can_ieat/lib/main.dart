import 'package:flutter/material.dart';
import 'face_login.dart';

void main() {
  runApp(FoodRecognitionApp());
}

class FoodRecognitionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Can iEat',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'SFPro',
      ),
      home: SplashPage(),
    );
  }
}

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FaceLoginPage()),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.orange.shade200, Colors.orange.shade400],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/logo.png',  // Assicurati che questo percorso sia corretto
                    width: 400,  // Imposta una dimensione maggiore per il logo
                    height: 400,  // Imposta una dimensione maggiore per il logo
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Can iEat',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SFPro',
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: Text(
                  'Gianluca Giuseppe Maria De Nardi',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'SFPro',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
