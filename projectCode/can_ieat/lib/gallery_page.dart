import 'package:can_ieat/profile_page.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'food_recognition_service.dart';
import 'photo_detection_page.dart';

class GalleryPage extends StatefulWidget {
  final List<String> images;

  GalleryPage({required this.images});

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final ImagePicker _picker = ImagePicker();
  final String apiKey = '1ca96709b7134f01a8cbe95b8488ce9c'; // Utilizza la chiave API fornita
  final String modelVersionId = '1d5fd481e0cf4826aa72ec3ff049e044'; // Utilizza il model version ID fornito
  String? _selectedImagePath;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
    }
  }

  Future<void> _recognizeFood() async {
    if (_selectedImagePath == null) {
      return;
    }
    final foodRecognitionService = FoodRecognitionService();
    final foodLabels = await foodRecognitionService.recognizeFood(_selectedImagePath!);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoDetectionPage(
          imagePath: _selectedImagePath!,
          recognitionResults: foodLabels, // Passa i risultati del riconoscimento
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gallery',
          style: TextStyle(
            fontFamily: 'SFPro',
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
        backgroundColor: Colors.deepOrange.shade50,
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.deepOrange.shade50,
            child: Column(
              children: [
                SizedBox(height: 70),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Image.asset(
                    'assets/select_image.png',
                    width: 100,
                    height: 100,
                  ),
                  label: Text(
                    '',
                    style: TextStyle(
                      fontFamily: 'SFPro',
                      fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.deepOrange.shade100,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  ),
                ),
                SizedBox(height: 5),
                if (_selectedImagePath != null)
                  Column(
                    children: [
                      Container(
                        height: 500, // Definisci l'altezza massima desiderata
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(45.0), // Specifica il raggio di smussatura
                          child: Image.file(
                            File(_selectedImagePath!),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: _recognizeFood,
                        child: Text(
                          'Recognize Food',
                          style: TextStyle(
                            fontFamily: 'SFPro',
                            fontSize: 20,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.deepOrange.shade100,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: widget.images.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 200, // Definisci l'altezza massima desiderata
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0), // Specifica il raggio di smussatura
                          child: Image.file(
                            File(widget.images[index]),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      );
                    },
                  ),
                ),
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
        ],
      ),
    );
  }
}
