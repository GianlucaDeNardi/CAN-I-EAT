import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'detail_page.dart';
import 'home_page.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _images = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final prefs = await SharedPreferences.getInstance();
    final imagesString = prefs.getString('historyImages');
    if (imagesString != null) {
      List<dynamic> jsonList = json.decode(imagesString);
      setState(() {
        _images = jsonList.map((item) => Map<String, dynamic>.from(item)).toList();
      });
    }
  }

  Future<void> _renameImage(int index, String newName) async {
    setState(() {
      _images[index]['recognitionResults'][0]['name'] = newName;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('historyImages', json.encode(_images));
  }

  Future<void> _deleteImage(int index) async {
    setState(() {
      _images.removeAt(index);
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('historyImages', json.encode(_images));
  }

  void _showRenameDialog(BuildContext context, int index) {
    final TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rename'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: "Enter new name"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Chiude il dialogo
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _renameImage(index, _controller.text);
                Navigator.of(context).pop(); // Chiude il dialogo
              },
              child: Text('Rename'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Do you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Chiude il dialogo
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _deleteImage(index);
                Navigator.of(context).pop(); // Chiude il dialogo
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History',
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
                SizedBox(height: 40), // Aggiungi uno spazio tra il titolo e il primo elemento
                Expanded(
                  child: ListView.builder(
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      final image = _images[index];
                      final recognitionResults = image['recognitionResults'] ?? [];
                      if (recognitionResults.isEmpty) {
                        return Container(); // Ignora se non ci sono risultati di riconoscimento
                      }
                      final label = recognitionResults.isNotEmpty ? _capitalize(recognitionResults[0]['name']) : 'No Label';
                      final timestamp = image['timestamp'] ?? 'No Timestamp';
                      return ListTile(
                        leading: ClipOval(
                          child: Image.file(
                            File(image['path']),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(label),
                        subtitle: Text(timestamp),
                        trailing: PopupMenuButton<String>(
                          onSelected: (String value) {
                            if (value == 'Rename') {
                              _showRenameDialog(context, index);
                            } else if (value == 'Delete') {
                              _showDeleteConfirmationDialog(context, index);
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return {'Rename', 'Delete'}.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(imageDetails: image),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                          (Route<dynamic> route) => false,
                    );
                  },
                  icon: Icon(
                    Icons.home,
                    size: 24,
                    color: Colors.black, // Colore dell'icona
                  ),
                  label: Text(
                    'Home',
                    style: TextStyle(
                      fontFamily: 'SFPro',
                      fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.deepOrange.shade100,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
