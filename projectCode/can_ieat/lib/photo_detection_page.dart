import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'history_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class PhotoDetectionPage extends StatelessWidget {
  final String imagePath;
  final List<Map<String, dynamic>> recognitionResults;

  PhotoDetectionPage({required this.imagePath, required this.recognitionResults});

  @override
  Widget build(BuildContext context) {
    // Leggi l'immagine dal file
    final imageBytes = File(imagePath).readAsBytesSync();

    String label;
    String confidence;

    if (recognitionResults.isNotEmpty) {
      label = recognitionResults[0]['name'];
      confidence = recognitionResults[0]['value'];
      if (double.tryParse(confidence)! < 20.0) {
        label = 'Not food detected';
      }
    } else {
      label = 'Food not detected';
      confidence = '0.00';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Food Detection',
          style: TextStyle(
            fontFamily: 'SFPro',
            fontWeight: FontWeight.bold,
            fontSize: 34,
          ),
        ),
        backgroundColor: Colors.deepOrange.shade50,
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.deepOrange.shade50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 600, // Imposta un'altezza fissa per l'immagine
                  width: double.infinity, // Occupa tutta la larghezza disponibile
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(45.0), // Specifica il raggio di smussatura
                    child: Image.memory(
                      imageBytes,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Are you eating? $label',
                  style: TextStyle(
                    fontFamily: 'SFPro',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Confidence: $confidence%',
                  style: TextStyle(
                    fontFamily: 'SFPro',
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        await _saveToHistory(context, recognitionResults, imagePath);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistoryPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          fontFamily: 'SFPro',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.deepOrange.shade100,
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'No',
                        style: TextStyle(
                          fontFamily: 'SFPro',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.deepOrange.shade100,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Image.asset(
              'assets/logo.png', // Assicurati che questo percorso sia corretto
              width: 50, // Imposta la larghezza desiderata del logo
              height: 50, // Imposta l'altezza desiderata del logo
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveToHistory(BuildContext context, List<Map<String, dynamic>> recognitionResults, String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd'); // Formato solo con la data
    final formattedDate = formatter.format(now);
    final image = {
      'path': imagePath,
      'recognitionResults': recognitionResults.isNotEmpty ? recognitionResults : [],
      'timestamp': formattedDate
    };

    final imagesString = prefs.getString('historyImages');
    List<Map<String, dynamic>> images = [];
    if (imagesString != null) {
      List<dynamic> jsonList = json.decode(imagesString);
      images = jsonList.map((item) => Map<String, dynamic>.from(item)).toList();
    }
    images.add(image);
    await prefs.setString('historyImages', json.encode(images));
  }
}
