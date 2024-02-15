import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

import '../util/global_function.dart';

class ProviderVerifyIdentity with ChangeNotifier {
  final options = FaceDetectorOptions();
  FaceDetector? _faceDetector;
  File? _imageFile;
  String? _base64Image = '';

  String get base64Image => _base64Image!;

  set base64Image(String value) {
    _base64Image = value;
  }

  File? get imageFile => _imageFile;

  set imageFile(File? value) {
    if (value != null) {
      _imageFile = value;
    }
  }

  void activeDetectionFace() {
    _faceDetector = FaceDetector(options: options);
  }

  void captureImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;
    File fileImage = File(image.path);
    GlobalFunction()
        .compressFile(GlobalFunction.context.currentContext!, fileImage, 3);
  }

  void detectedImage(File file) async {
    _imageFile = file;
    InputImage inputImage = InputImage.fromFilePath(file.path);
    try {
      final faces = await _faceDetector!.processImage(inputImage);
      if (faces.isNotEmpty) {
        base64Image = base64Encode(File(file.path).readAsBytesSync());
      } else {}
    } catch (error) {
      if (kDebugMode) {
        print('ERROR VERIFY IDENTITY >> $error');
      }
    }
    notifyListeners();
  }

  void deleteImage() {
    _imageFile = null;
    _base64Image = '';
    notifyListeners();
  }
}
