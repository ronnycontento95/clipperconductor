
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../data/response/response_user.dart';
import '../../domain/entities/model_login.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_preference.dart';
import 'provider_service/provider_service_rest.dart';

class ProviderLogin with ChangeNotifier {
  TextEditingController editUser = TextEditingController();
  TextEditingController editPassword = TextEditingController();
  bool? _stateShowEditPassword = true;
  ModelLogIn? modelLogIn = ModelLogIn();
  bool? _stateBiometric = false;
  GoogleSignIn? googleSignIn = GoogleSignIn();
  ResponseUser? _responseUser = ResponseUser();

  ResponseUser get responseUser => _responseUser!;

  set responseUser(ResponseUser value) {
    _responseUser = value;
    notifyListeners();
  }

  bool get stateShowEditPassword => _stateShowEditPassword!;

  set stateShowEditPassword(bool value) {
    _stateShowEditPassword = value;
  }

  /// Show and hide password
  void showPassword() {
    if (!_stateShowEditPassword!) {
      _stateShowEditPassword = true;
    } else {
      _stateShowEditPassword = false;
    }
    notifyListeners();
  }

  bool get stateBiometric => _stateBiometric!;

  set stateBiometric(bool value) {
    _stateBiometric = value;
    notifyListeners();
  }

  void initLogIn(BuildContext context) {
    final prServiceSocketRead = context.read<ProviderServiceRest>();

    if (editUser.text.trim().isEmpty) {
      return GlobalFunction().messageAlert(context, GlobalLabel.textEmptyUser);
    }

    if (editPassword.text.trim().isEmpty) {
      return GlobalFunction()
          .messageAlert(context, GlobalLabel.textEmptyPassword);
    }


    GlobalPreference.getDataDispositive().then((dataDispositive) {
      modelLogIn!.user = editUser.text.trim();
      modelLogIn!.version = dataDispositive!.version;
      modelLogIn!.password =
          GlobalFunction().generatedMd5(editPassword.text.trim());
      modelLogIn!.deviceId =
          GlobalFunction().generatedSHA256(dataDispositive.imei);
      modelLogIn!.applicationId = GlobalLabel.idApplication;

      prServiceSocketRead.initLogInApp(context, modelLogIn!);
    });
  }

  /// Clean text field user and password
  void cleanTextField() {
    editUser.clear();
    editPassword.clear();
    notifyListeners();
  }
}
