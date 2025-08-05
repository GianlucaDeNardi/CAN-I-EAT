import 'package:flutter/material.dart';

class EasterEggPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/easteregg.png', // Assicurati che l'immagine esista in questo percorso
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
