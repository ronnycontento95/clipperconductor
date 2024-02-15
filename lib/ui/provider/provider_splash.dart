import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../domain/entities/model_dispositive.dart';
import '../page/page_login.dart';
import '../page/page_slider.dart';
import '../util/global_function.dart';
import '../util/global_preference.dart';

class ProviderSplash with ChangeNotifier {
  DeviceInfoPlugin? deviceInfoPlugin = DeviceInfoPlugin();
  ModelDispositive _modelDispositive = ModelDispositive();
  PackageInfo? packageInfo;
  IosDeviceInfo? iosDeviceInfo;
  AndroidDeviceInfo? androidDeviceInfo;
  bool? _statusPage = false;

  bool get statusPage => _statusPage!;

  set statusPage(bool value) {
    _statusPage = value;
  }

  void informationDispositive() async {
    packageInfo = await PackageInfo.fromPlatform();
    _modelDispositive = ModelDispositive();
    if (Platform.isAndroid) {
      androidDeviceInfo = await deviceInfoPlugin!.androidInfo;
      _modelDispositive.imei = androidDeviceInfo!.id;
      _modelDispositive.model = androidDeviceInfo!.model;
      _modelDispositive.brand =
          '${androidDeviceInfo!.manufacturer} ${androidDeviceInfo!.model}';
      _modelDispositive.version = packageInfo!.version;
      _modelDispositive.versionSystem = androidDeviceInfo!.version.release;
    } else {
      iosDeviceInfo = await deviceInfoPlugin!.iosInfo;
      _modelDispositive.imei = iosDeviceInfo!.identifierForVendor!;
      _modelDispositive.model = iosDeviceInfo!.model;
      _modelDispositive.brand = iosDeviceInfo!.name;
      _modelDispositive.version = packageInfo!.version;
      _modelDispositive.versionSystem = iosDeviceInfo!.systemVersion;
    }
    GlobalPreference().setDataDispositive(_modelDispositive);
  }

  /// Type 1: Send from splash
  void startApp(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      GlobalPreference.getDataUser().then((dataUser) {
        if (dataUser == null) {
          GlobalFunction().nextPageUntilView(const PageSlider());
        } else {
          GlobalPreference.getStateLogin().then((stateLogin) {
            if (stateLogin) {
              GlobalFunction().initialApplicative();
            } else {
              GlobalFunction().nextPageUntilView(const PageLogin());
            }
          });
        }
      });
    });
  }
}
