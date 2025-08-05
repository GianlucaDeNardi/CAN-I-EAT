import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class FoodRecognitionService {
  final String apiKey = '1ca96709b7134f01a8cbe95b8488ce9c';
  final String modelVersionId = '1d5fd481e0cf4826aa72ec3ff049e044';

  Future<List<Map<String, dynamic>>> recognizeFood(String imagePath) async {
    final url = 'https://api.clarifai.com/v2/users/clarifai/apps/main/models/food-item-recognition/versions/$modelVersionId/outputs';
    final imageBytes = await File(imagePath).readAsBytes();
    final base64Image = base64Encode(imageBytes);

    final requestPayload = {
      "inputs": [
        {
          "data": {
            "image": {
              "base64": base64Image
            }
          }
        }
      ]
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Key $apiKey",
        },
        body: jsonEncode(requestPayload),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final concepts = jsonResponse['outputs'][0]['data']['concepts'];
        if (concepts.isNotEmpty) {
          final foodLabels = concepts.map<Map<String, dynamic>>((concept) {
            return {
              'name': concept['name'],
              'value': (concept['value'] * 100).toStringAsFixed(2)
            };
          }).toList();
          return foodLabels;
        } else {
          return [{'name': 'Food not detected!', 'value': '0.00'}];
        }
      } else {
        throw Exception('Failed to recognize food');
      }
    } catch (e) {
      return [{'name': 'Food not detected!', 'value': '0.00'}];
    }
  }
}

class RecognitionResultPage extends StatelessWidget {
  final String imagePath;
  final List<Map<String, dynamic>> recognitionResults;

  RecognitionResultPage({required this.imagePath, required this.recognitionResults});

  @override
  Widget build(BuildContext context) {
    final imageBytes = File(imagePath).readAsBytesSync();

    final image = img.decodeImage(imageBytes);
    if (image == null) {
      throw Exception('Failed to decode image');
    }

    final resizedImage = img.copyResize(image, width: 224);
    final resizedImageBytes = Uint8List.fromList(img.encodeJpg(resizedImage));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recognition Results',
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.memory(resizedImageBytes),
                  SizedBox(height: 20),
                  Text(
                    'Recognition Results:',
                    style: TextStyle(
                      fontFamily: 'SFPro',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: recognitionResults.length,
                      itemBuilder: (context, index) {
                        final item = recognitionResults[index];
                        return ListTile(
                          title: Text(
                            item['name'],
                            style: TextStyle(
                              fontFamily: 'SFPro',
                            ),
                          ),
                          subtitle: Text(
                            'Confidence: ${item['value']}%',
                            style: TextStyle(
                              fontFamily: 'SFPro',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
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
          Positioned(
            bottom: 20,
            right: 20,
            child: Text(
              'Gianluca Giuseppe Maria De Nardi',
              style: TextStyle(
                fontFamily: 'SFPro',
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
