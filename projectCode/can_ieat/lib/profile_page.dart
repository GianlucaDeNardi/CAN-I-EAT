import 'package:flutter/material.dart';
import 'easteregg_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _tapCounter = 0;

  void _onImageTapped() {
    setState(() {
      _tapCounter++;
      if (_tapCounter >= 10) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EasterEggPage()),
        );
        _tapCounter = 0; // Reset counter after navigation
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'SFPro',
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
        backgroundColor: Colors.deepOrange.shade50,
      ),
      body: Container(
        color: Colors.deepOrange.shade50,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: GestureDetector(
                onTap: _onImageTapped,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    'assets/profile_image.png', // Assicurati che l'immagine esista in questo percorso
                    width: screenWidth,
                    height: screenWidth, // Mantiene un rapporto di aspetto 3:2
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Gianluca Giuseppe Maria De Nardi',
                style: TextStyle(
                  fontFamily: 'SFPro',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Email',
              style: TextStyle(
                fontFamily: 'SFPro',
                fontSize: 18,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'gianlucagiuseppe.denardi@gmail.com',
              style: TextStyle(
                fontFamily: 'SFPro',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Phone number',
              style: TextStyle(
                fontFamily: 'SFPro',
                fontSize: 18,
              ),
            ),
            SizedBox(height: 5),
            Text(
              '+223424224',
              style: TextStyle(
                fontFamily: 'SFPro',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
