import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'allergen_icons.dart';  // Importa il file allergen_icons.dart

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> imageDetails;

  DetailPage({required this.imageDetails});

  @override
  Widget build(BuildContext context) {
    final imagePath = imageDetails['path'];
    final recognitionResults = List<Map<String, dynamic>>.from(imageDetails['recognitionResults'] ?? []);
    final timestamp = imageDetails['timestamp'] ?? 'No Timestamp';

    final imageBytes = File(imagePath).readAsBytesSync();

    // Decodifica l'immagine
    final image = img.decodeImage(imageBytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Ridimensiona l'immagine
    final resizedImage = img.copyResize(image, width: 224); // Imposta la larghezza desiderata, mantiene il rapporto di aspetto

    // Codifica di nuovo l'immagine in JPEG
    final resizedImageBytes = Uint8List.fromList(img.encodeJpg(resizedImage));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          recognitionResults.isNotEmpty ? recognitionResults[0]['name'] : 'No Label',
          style: TextStyle(
            fontFamily: 'SFPro',
            fontWeight: FontWeight.bold,
            fontSize: 34,
          ),
        ),
        backgroundColor: Colors.deepOrange.shade50,
      ),
      body: Container(
        color: Colors.deepOrange.shade50, // Imposta lo stesso colore di sfondo del corpo
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0), // Specifica il raggio di smussatura
                child: Image.memory(resizedImageBytes),
              ),
              SizedBox(height: 20),
              Text(
                'Date: $timestamp',
                style: TextStyle(
                  fontFamily: 'SFPro',
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Ingredients:',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'SFPro',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: recognitionResults.skip(1).where((item) => double.parse(item['value']) >= 50.0).map((item) {
                    final iconPath = allergenIcons[item['name'].toLowerCase()] ?? 'assets/icons/default.png';
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.shade100,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(iconPath, width: 32, height: 32),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _capitalize(item['name']),
                                style: TextStyle(
                                  fontFamily: 'SFPro',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '${item['value']}%',
                                style: TextStyle(
                                  fontFamily: 'SFPro',
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
