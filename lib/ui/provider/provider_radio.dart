import 'package:flutter/cupertino.dart';

class ProviderRadio with ChangeNotifier{
  bool? _isRecording = false;

  bool get isRecording => _isRecording!;

  set isRecording(bool value) {
    _isRecording = value;
  }
}