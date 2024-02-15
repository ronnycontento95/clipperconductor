import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../data/response/response_country.dart';
import '../../domain/entities/model_country.dart';
import '../../domain/entities/model_pre_registration.dart';

import '../page/page_option_register.dart';
import '../page/page_register_country.dart';
import '../page/page_register_name.dart';
import '../page/page_register_phone.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';

class ProviderPreRegister extends ChangeNotifier {
  TextEditingController editName = TextEditingController();
  TextEditingController editLastName = TextEditingController();
  TextEditingController editNumber = TextEditingController();
  TextEditingController editCommentary = TextEditingController();
  TextEditingController editReferred = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  ModelPreRegistration? _preRegistration = ModelPreRegistration();
  PhoneNumber? _codeCountry = PhoneNumber(isoCode: 'EC', dialCode: "+593");
  bool? _stateNumberValidate = false;
  bool? _optionRegisterOne = false;
  bool? _optionRegisterTwo = false;
  String? _idOTP;
  String? _hashtag = '';
  List<ModelCountry>? listCountry = [];
  List<City> listCity = [];
  UserCredential? userCredential;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignIn get googleSignIn => _googleSignIn;

  String get hashtag => _hashtag!;

  set hashtag(String value) {
    _hashtag = value;
    notifyListeners();
  }

  String get idOTP => _idOTP!;

  set idOTP(String value) {
    _idOTP = value;
    notifyListeners();
  }


  ModelPreRegistration get preRegistration => _preRegistration!;

  set preRegistration(ModelPreRegistration value) {
    _preRegistration = value;
  }

  PhoneNumber get codeCountry => _codeCountry!;

  set codeCountry(PhoneNumber value) {
    _codeCountry = value;
  }

  bool get stateNumberValidate => _stateNumberValidate!;

  set stateNumberValidate(bool value) {
    _stateNumberValidate = value;
  }

  bool get optionRegisterOne => _optionRegisterOne!;

  set optionRegisterOne(bool value) {
    _optionRegisterOne = value;
  }

  bool get optionRegisterTwo => _optionRegisterTwo!;

  set optionRegisterTwo(bool value) {
    _optionRegisterTwo = value;
  }

  /// Clean all text field the form and reset variable boolean
  cleanAllTextField() {
    editName.clear();
    editLastName.clear();
    editNumber.clear();
    editCommentary.clear();
    editReferred.clear();
    _optionRegisterOne = false;
    _optionRegisterTwo = false;
    _stateNumberValidate = false;
    notifyListeners();
  }

  /// Get data user with login facebook
  Future loginFacebook() async {
    await FacebookAuth.instance.logOut();
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      FacebookAuth.instance.getUserData().then((userData) {
        _preRegistration!.email = userData['email'];
        _preRegistration!.name = userData['name'].toString().split(' ')[0];
        _preRegistration!.lastName = userData['name'].toString().split(' ')[1];
        notifyListeners();
        getNameLastName();
        GlobalFunction().nextPageViewTransition(const PageRegisterName());
      });
    } else if (result.status == LoginStatus.cancelled) {
      GlobalFunction().messageAlert(GlobalFunction.context.currentContext!,
          GlobalLabel.textProcessCanceled);
    } else {
      GlobalFunction().messageAlert(
          GlobalFunction.context.currentContext!, GlobalLabel.textNoData);
    }
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  /// Get data user with login google
  Future loginGoogle(BuildContext context) async {
    try {
      if (await googleSignIn.isSignedIn()) await googleSignIn.disconnect();
      await googleSignIn.signIn();
    } catch (error) {
      if (kDebugMode) {
        print("ERROR >>> LOGIN GOOGLE $error");
      }
    }

    if (googleSignIn.currentUser == null) {
      return null;
    }
    final String fullName = googleSignIn.currentUser!.displayName!;
    final String email = googleSignIn.currentUser!.email;
    _preRegistration!.email = email;
    if (fullName.contains(' ')) {
      _preRegistration!.name = fullName.split(' ')[0];
      _preRegistration!.lastName = fullName.split(' ')[1];
    } else {
      _preRegistration!.name = fullName;
    }
    notifyListeners();
    getNameLastName();
    GlobalFunction().nextPageViewTransition(const PageRegisterName());
    return null;
  }

  Future loginApple() async {
    try {
      final result = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      String? givenName = result.givenName;
      final String? familyName = result.familyName;
      String? email = result.email;

      final rawNonce = generateNonce();

      final AuthCredential appleAuthCredential =
          OAuthProvider('apple.com').credential(
        idToken: result.identityToken,
        rawNonce: Platform.isIOS ? rawNonce : null,
        accessToken: Platform.isIOS ? null : result.authorizationCode,
      );
      userCredential =
          await FirebaseAuth.instance.signInWithCredential(appleAuthCredential);
      if (userCredential != null &&
          userCredential!.user != null &&
          userCredential!.user!.providerData.first.uid != null) {
        email = userCredential!.user!.email;
        if (givenName?.isEmpty ?? true) {
          givenName = email!.split("@").first;
        }
        _preRegistration!.name = givenName;
        _preRegistration!.lastName = familyName ?? "";
        _preRegistration!.email = email!;
        notifyListeners();
        getNameLastName();
        GlobalFunction().nextPageViewTransition(const PageRegisterName());
      }
    } catch (error) {
      if (kDebugMode) {
        print("ERROR >>> APPLE ID $error");
      }
    }
  }

  /// Retrieve first and last name from previous view
  getNameLastName() {
    editName.text = _preRegistration!.name!;
    editLastName.text = _preRegistration!.lastName!;
    notifyListeners();
  }

  /// Validate text field name and password is not empty
  validateTextFieldName(BuildContext context) {
    if (editName.text.trim().isEmpty) {
      GlobalFunction().messageAlert(context, GlobalLabel.textWriteName);
      return;
    }

    if (editLastName.text.trim().isEmpty) {
      GlobalFunction().messageAlert(context, GlobalLabel.textWriteLastName);
      return;
    }
    _preRegistration!.name = editName.text.trim();
    _preRegistration!.lastName = editLastName.text.trim();
    _stateNumberValidate = false;
    notifyListeners();
    GlobalFunction().nextPageViewTransition(const PageRegisterPhone());
  }

  /// Validate text field number phone is not empty
  validatePhone(BuildContext context, String codeCountry, String phone) {
    if (phoneValid(codeCountry, phone)) {
      GlobalFunction().nextPageViewTransition(const PageRegisterCountry());
      return null;
    }
    return GlobalFunction().messageAlert(context, GlobalLabel.textInvalidCellPhone);
  }


  static bool phoneValid(String? countryCode, String? phone) {
    switch (countryCode ?? "") {
      case "+593":

        /// For Ecuador
        if (phone!.startsWith("0")) {
          if (phone.length != 10) {
            return false;
          }
        } else {
          if (phone.length != 9) {
            return false;
          }
        }
        String pattern = r'(^(9)([0-9]){8}$)';
        RegExp regExp = RegExp(pattern);
        return regExp
            .hasMatch(phone.startsWith("0") ? phone.substring(1) : phone);
      case "+591": //Para Bolivia
        if (phone!.length != 8) {
          return false;
        }
        String pattern = r'(^(6|7)([0-9]){7}$)';
        RegExp regExp = RegExp(pattern);
        return regExp.hasMatch(phone);
      case "+57": //Para Colombia
        if (phone!.length != 10) {
          return false;
        }
        String pattern = r'(^(3)([0-9]){9}$)';
        RegExp regExp = RegExp(pattern);
        return regExp.hasMatch(phone);
      case "+51": //Para peru
      case "+56": //Para chile
        if (phone!.length != 9) {
          return false;
        }
        String pattern = r'(^(9)([0-9]){8}$)';
        RegExp regExp = RegExp(pattern);
        return regExp.hasMatch(phone);
      case "+52": //Para Mexico
        if (phone!.length == 10 || phone.length == 11) {
          return true;
        }
        return false;
      case "+34": //Para españa
        if (phone!.length == 9) {
          return true;
        }
        return false;
    }
    return true;
  }

  /// Send number phone to firebase
  sendNumberToFirebase() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '${_codeCountry!.dialCode ?? '+593'}${editNumber.text}',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        switch (e.code) {
          case 'invalid-phone-number':
            _stateNumberValidate = false;
            GlobalFunction().hideProgress();
            GlobalFunction().messageAlert(
                GlobalFunction.context.currentContext!,
                GlobalLabel.textInvalidateNumber);
            break;
          case 'too-many-requests':
            _stateNumberValidate = false;
            GlobalFunction().hideProgress();
            GlobalFunction().messageAlert(
                GlobalFunction.context.currentContext!,
                GlobalLabel.textMessageError);
            break;
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        GlobalFunction().deleteFocusForm();
        GlobalFunction().hideProgress();
        _stateNumberValidate = true;
        _idOTP = verificationId;
        notifyListeners();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  /// Add country to the list
  addListCity(ResponseCountry responseCountry) {
    if (listCountry!.isNotEmpty) {
      listCountry!.clear();
    }
    listCountry!.addAll(responseCountry.lCountry!);
    addCityForCountry(0);
    selectionCountryList(0);
    notifyListeners();
  }

  /// Add city to the list selecting on country
  addCityForCountry(int position) {
    if (listCity.isNotEmpty) {
      listCity.clear();
    }
    for (ModelCountry country in listCountry!) {
      if (country.idCountry == listCountry![position].idCountry) {
        listCity.addAll(country.lCity!);
      }
    }
    notifyListeners();
  }

  /// Selecting country of the list
  selectionCountryList(int position) {
    for (ModelCountry country in listCountry!) {
      if (country.idCountry == listCountry![position].idCountry) {
        country.stateSelection = true;
        _preRegistration!.selectedCountry = country.country;
      } else {
        country.stateSelection = false;
      }
    }
    _preRegistration!.selectedCountry = '';
    addCityForCountry(position);
    notifyListeners();
  }

  /// Selecting city of the list
  selectedCityList(int idCity) {
    for (City city in listCity) {
      if (city.idCity == idCity) {
        city.stateSelection = true;
        _preRegistration!.selectedCity = city.city!;
      } else {
        city.stateSelection = false;
      }
    }
    notifyListeners();
  }

  /// Selecting motive registration
  /// Type = 1: User drive
  /// Type = 2: User representative
  addMotive(bool message, int type) {
    if (type == 1) {
      _hashtag = GlobalLabel.textHashtagDriver;
      _optionRegisterOne = message;
      _optionRegisterTwo = false;
    } else {
      _hashtag = GlobalLabel.textHashtagRepresentative;
      _optionRegisterTwo = message;
      _optionRegisterOne = false;
    }
    notifyListeners();
  }

  /// Validate selecting city is not empty
  validateSelectedCity(BuildContext context) {
    if (_preRegistration!.selectedCity == null ||
        _preRegistration!.selectedCity!.isEmpty) {
      GlobalFunction().messageAlert(context, GlobalLabel.textSelectedLocation);
      return;
    }
    GlobalFunction().nextPageViewTransition(const PageOptionRegister());
  }
}
