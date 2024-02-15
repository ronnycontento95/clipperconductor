import 'package:flutter/cupertino.dart';

import '../../data/response/response_contact_user.dart';
import '../../domain/entities/model_contact_user.dart';

class ProviderContact with ChangeNotifier {
  TextEditingController editName = TextEditingController();
  TextEditingController editContact = TextEditingController();
  List<ModelContactUser>? listContactUser = [];
  bool? _contList = false;

  bool get contList => _contList!;

  set contList(bool value) {
    _contList = value;
  }

  /// Clear text field contact
  void clearEditContact() {
    editContact.clear();
    notifyListeners();
  }

  /// Clear text field name
  void clearEditName() {
    editName.clear();
    notifyListeners();
  }

  /// Clear all text field
  void clearAllEdit() {
    editName.clear();
    editContact.clear();
    notifyListeners();
  }

  /// Add contact to list
  void addListContact(ResponseContactUser responseContactUser) {
    if (listContactUser!.isNotEmpty) listContactUser!.clear();
    listContactUser!.addAll(responseContactUser.lC!);
    if (listContactUser!.isNotEmpty) {
      _contList = false;
    } else {
      _contList = true;
    }
    notifyListeners();
  }

  /// Update state contact list
  void updateStateListContact(int type, int idContact) {
    for (ModelContactUser contactUser in listContactUser!) {
      if (contactUser.idContactUser == idContact) {
        if (type == 1) {
          contactUser.state = 1;
        } else {
          contactUser.state = 0;
        }
        break;
      }
    }
    notifyListeners();
  }


}