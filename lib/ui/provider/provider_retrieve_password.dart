import 'package:flutter/cupertino.dart';

class ProviderRetrievePassword with ChangeNotifier {
  TextEditingController editPhone = TextEditingController();
  bool? _stateTextFieldPassword = false;

  bool get stateTextFieldPassword => _stateTextFieldPassword!;

  set stateTextFieldPassword(bool value) {
    _stateTextFieldPassword = value;
  }

  /// Clean all text field
  cleanTextField() {
    editPhone.clear();
    notifyListeners();
  }

}
