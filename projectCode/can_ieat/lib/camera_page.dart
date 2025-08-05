import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'food_recognition_service.dart';
import 'photo_detection_page.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras![0], ResolutionPreset.high);
    _initializeControllerFuture = controller!.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _recognizeFood(String imagePath) async {
    final foodRecognitionService = FoodRecognitionService(
    );
    final foodLabels = await foodRecognitionService.recognizeFood(imagePath);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoDetectionPage(
          imagePath: imagePath,
          recognitionResults: foodLabels, // Passa i risultati del riconoscimento
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(controller!);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final path = join(
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );
            final XFile image = await controller!.takePicture();
            await image.saveTo(path);

            _recognizeFood(path);
          } catch (e) {
            print('Error taking picture: $e');
          }
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
