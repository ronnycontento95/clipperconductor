import 'package:flutter/cupertino.dart';

import '../../data/response/response_user_operator.dart';
import '../../domain/entities/model_user_operator.dart';

class ProviderRegisterDispositive with ChangeNotifier {
  int? _typeRegisterDispositive = 0;
  String? _message = '';
  List<ModelUserOperator>? listUserOperator = [];
  int? _iU;

  int get iU => _iU!;

  set iU(int value) {
    _iU = value;
  }

  String get message => _message!;

  set message(String value) {
    _message = value;
  }

  int get typeRegisterDispositive => _typeRegisterDispositive!;

  set typeRegisterDispositive(int value) {
    _typeRegisterDispositive = value;
  }

  /// Add operator to the list
  void addListUserOperator(
      ResponseUserOperator responseUserOperator, String message) {
    if (listUserOperator!.isNotEmpty) listUserOperator!.clear();
    listUserOperator!.addAll(responseUserOperator.data!);
    _message = message;
    notifyListeners();
  }
}
