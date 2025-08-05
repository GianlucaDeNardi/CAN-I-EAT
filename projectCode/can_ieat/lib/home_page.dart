import 'package:flutter/material.dart';
import 'camera_page.dart';
import 'gallery_page.dart';
import 'history_page.dart';
import 'profile_page.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
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
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CameraPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      backgroundColor: Colors.deepOrange.shade100,
                      padding: EdgeInsets.all(10),
                    ),
                    child: Container(
                      child: CircleAvatar(
                        radius: 170,
                        backgroundColor: Colors.transparent,
                        child: Image.asset('assets/camera_icon.png'),
                      ),
                    ),
                  ),
                  SizedBox(height: 70),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GalleryPage(images: []), // Passa un elenco vuoto per iniziare
                        ),
                      );
                    },
                    icon: Icon(Icons.photo_album, size: 32, color: Colors.black), // Icona della galleria
                    label: Text(
                      'Gallery',
                      style: TextStyle(
                        fontFamily: 'SFPro',
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange.shade100,
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    ),
                  ),
                  SizedBox(height: 20), // Spazio tra i pulsanti
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryPage(),
                        ),
                      );
                    },
                    icon: Icon(Icons.history, size: 32, color: Colors.black), // Icona della cronologia
                    label: Text(
                      'History',
                      style: TextStyle(
                        fontFamily: 'SFPro',
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange.shade100,
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    ),
                  ),
                  SizedBox(height: 35), // Spazio finale per padding inferiore
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
                child: Image.asset(
                  'assets/logo.png', // Assicurati che questo percorso sia corretto
                  width: 50, // Imposta la larghezza desiderata del logo
                  height: 50, // Imposta l'altezza desiderata del logo
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SplashPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange.shade100,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
