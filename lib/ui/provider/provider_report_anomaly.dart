import 'dart:io';
import 'package:flutter/material.dart';

class ProviderReportAnomaly extends ChangeNotifier{
  List<File>? listImage = [];
  TextEditingController editLate = TextEditingController();
  TextEditingController editColor = TextEditingController();
  TextEditingController editCommentary = TextEditingController();

  /// Delete image
  void deleteImage() {
    listImage!.clear();
    notifyListeners();
  }

  /// Delete text edit late
  void cleanTextFieldEditLate() {
    editLate.clear();
    notifyListeners();
  }

  /// Delete text edit color
  void cleanTextEditColor() {
    editColor.clear();
    notifyListeners();
  }

  /// Delete text edit commentary
  void cleanTextEditCommentary() {
    editCommentary.clear();
    notifyListeners();
  }

  /// Delete All
  void cleanTextAll(){
    deleteImage();
    cleanTextFieldEditLate();
    cleanTextEditColor();
    cleanTextEditCommentary();
  }

  /// Add image
  void addImage(File photo) {
    if (listImage!.isNotEmpty) listImage!.clear();
    listImage!.add(photo);
    notifyListeners();
  }
}