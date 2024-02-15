import 'package:flutter/cupertino.dart';

class ProviderSlider with ChangeNotifier {
  int? _positionSlider = 0;

  int get positionSlider => _positionSlider!;

  set positionSlider(int value) {
    _positionSlider = value;
  }

  void updatePositionSlider(int index) {
    _positionSlider = index;
    notifyListeners();
  }
}
