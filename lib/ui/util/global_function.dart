import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:app_version_update/app_version_update.dart';
import 'package:app_version_update/data/models/app_version_result.dart';
import 'package:clipp_conductor/ui/provider/provider_verify_identity.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:http/http.dart' as http;

import 'package:archive/archive.dart';

import 'package:audio_wave/audio_wave.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dash_bubble/dash_bubble.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart' as alert;
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../provider/provider_chat_request.dart';
import '../provider/provider_map.dart';
import '../provider/provider_payment.dart';
import '../provider/provider_principal.dart';
import '../provider/provider_report_anomaly.dart';
import '../provider/provider_service/provider_service_socket.dart';
import '../provider/provider_taximeter.dart';
import 'global_colors.dart';
import 'global_label.dart';
import 'dart:ui' as ui;

import 'global_widgets/widget_container.dart';
import 'global_widgets/widget_divider.dart';
import 'global_widgets/widget_progress.dart';
import 'global_widgets/widget_text_field_personalized.dart';
import 'global_widgets/widget_text_field_sub_title.dart';
import 'package:vector_math/vector_math.dart' as math;

import 'global_widgets/widget_text_field_title.dart';

class GlobalFunction {
  static GlobalKey<NavigatorState> context = GlobalKey<NavigatorState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  AudioPlayer player = AudioPlayer();
  FlutterTts flutterTts = FlutterTts();
  final hourNow = TimeOfDay.now().hour;
  final minuteNow = TimeOfDay.now().minute;
  final dateNow = DateTime.now();
  final hour = DateFormat('HH:mm:ss');
  final date = DateFormat('yyyy-MM-dd');
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  List<String> optionTime = ['+1', '+2', '+3', '+4', '+5'];

  /// Set color bar in all page
  SystemUiOverlayStyle colorBarView() {
    return SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness:
            Platform.isIOS ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: GlobalColors.colorBackground);
  }

  /// Transition new page view
  void nextPageViewTransition(Widget newPage) {
    Navigator.push(GlobalFunction.context.currentContext!,
        PageTransition(type: PageTransitionType.fade, child: newPage));
  }

  /// Transition new page view and delete history navigation
  void nextPageUntilView(Widget newPage) {
    Navigator.of(GlobalFunction.context.currentContext!).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => newPage),
        (Route<dynamic> route) => false);
  }

  /// Show message alter
  void messageAlert(BuildContext context, String message) {
    player.play(AssetSource(GlobalLabel.directionAudio));
    final snackBar = SnackBar(
        backgroundColor: GlobalColors.colorBackgroundBlue,
        content: Text(message,
            style: const TextStyle(
                fontFamily: GlobalLabel.typeLetterSubTitle,
                fontSize: 14,
                color: GlobalColors.colorWhite),
            textAlign: TextAlign.center));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Method generated text with encryption MD5
  generatedMd5(data) {
    return md5.convert(utf8.encode(data)).toString();
  }

  /// Method generate text with encryption SHA256
  generatedSHA256(input) {
    return sha256.convert(utf8.encode(input)).toString();
  }

  /// Format image marker
  Future<Uint8List> assetToBytes(String path) async {
    final byteData = await rootBundle.load(path);
    final byte = byteData.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(byte);
    final frame = await codec.getNextFrame();
    final newByteData = await frame.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return newByteData!.buffer.asUint8List();
  }

  /// Speck message
  void speakMessage(String message) {
    flutterTts.awaitSpeakCompletion(true);
    flutterTts.speak(message);
  }

  /// Show message confirmation
  messageConfirmation(String description, VoidCallback? callbackAccept,
      {title = GlobalLabel.textConfirmation,
      activeButtonCancel = true,
      onWillPop = false}) async {
    return alert.Alert(
      context: GlobalFunction.context.currentContext!,
      type: alert.AlertType.none,
      title: title,
      desc: description,
      style: alert.AlertStyle(
        isCloseButton: false,
        alertElevation: 0,
        backgroundColor: GlobalColors.colorWhite,
        overlayColor: GlobalColors.colorBlack.withOpacity(.4),
        isOverlayTapDismiss: true,
        descStyle: const TextStyle(
            fontFamily: GlobalLabel.typeLetterSubTitle,
            fontSize: 16,
            color: GlobalColors.colorLetterTitle),
        descTextAlign: TextAlign.center,
        titleTextAlign: TextAlign.left,
        animationDuration: const Duration(milliseconds: 250),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: GlobalColors.colorBorder),
        ),
        titleStyle: const TextStyle(
            color: GlobalColors.colorLetterTitle,
            fontSize: 18,
            fontFamily: GlobalLabel.typeLetterTitle),
        alertAlignment: Alignment.center,
      ),
      onWillPopActive: onWillPop,
      buttons: [
        if (activeButtonCancel)
          alert.DialogButton(
            onPressed: () {
              Navigator.pop(GlobalFunction.context.currentContext!);
            },
            border: const Border.fromBorderSide(
              BorderSide(
                color: GlobalColors.colorBorder,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
            color: GlobalColors.colorWhite,
            child: const Text(
              GlobalLabel.buttonCancel,
              style: TextStyle(
                  color: GlobalColors.colorLetterTitle,
                  fontSize: 16,
                  fontFamily: GlobalLabel.typeLetterTitle),
            ),
          ),
        alert.DialogButton(
          onPressed: () {
            Navigator.pop(GlobalFunction.context.currentContext!);
            if (callbackAccept != null) {
              callbackAccept();
            }
          },
          color: GlobalColors.colorButton,
          child: const Text(
            GlobalLabel.buttonAccept,
            style: TextStyle(
                color: GlobalColors.colorWhite,
                fontSize: 16,
                fontFamily: GlobalLabel.typeLetterTitle),
          ),
        )
      ],
    ).show();
  }

  /// Show message accept and cancel
  messageAcceptCancel(
    String description,
    VoidCallback? callbackAccept,
    VoidCallback? callbackCancel, {
    title = GlobalLabel.textConfirmation,
    activeButtonCancel = true,
    onWillPop = false,
  }) async {
    return alert.Alert(
      context: GlobalFunction.context.currentContext!,
      type: alert.AlertType.none,
      title: title,
      desc: description,
      style: alert.AlertStyle(
        isCloseButton: false,
        alertElevation: 0,
        backgroundColor: GlobalColors.colorWhite,
        overlayColor: GlobalColors.colorBlack.withOpacity(.4),
        isOverlayTapDismiss: true,
        descStyle: const TextStyle(
            fontFamily: GlobalLabel.typeLetterSubTitle,
            fontSize: 16,
            color: GlobalColors.colorLetterTitle),
        descTextAlign: TextAlign.center,
        titleTextAlign: TextAlign.left,
        animationDuration: const Duration(milliseconds: 250),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: GlobalColors.colorBorder),
        ),
        titleStyle: const TextStyle(
            color: GlobalColors.colorLetterTitle,
            fontSize: 18,
            fontFamily: GlobalLabel.typeLetterTitle),
        alertAlignment: Alignment.center,
      ),
      onWillPopActive: onWillPop,
      buttons: [
        if (activeButtonCancel)
          alert.DialogButton(
            onPressed: () {
              Navigator.pop(GlobalFunction.context.currentContext!);
              if (callbackCancel != null) {
                callbackCancel();
              }
            },
            border: const Border.fromBorderSide(
              BorderSide(
                color: GlobalColors.colorBorder,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
            color: GlobalColors.colorWhite,
            child: const Text(
              GlobalLabel.buttonCancel,
              style: TextStyle(
                color: GlobalColors.colorLetterTitle,
                fontSize: 16,
                fontFamily: GlobalLabel.typeLetterTitle,
              ),
            ),
          ),
        alert.DialogButton(
          onPressed: () {
            Navigator.pop(GlobalFunction.context.currentContext!);
            if (callbackAccept != null) {
              callbackAccept();
            }
          },
          color: GlobalColors.colorButton,
          child: const Text(
            GlobalLabel.buttonAccept,
            style: TextStyle(
              color: GlobalColors.colorWhite,
              fontSize: 16,
              fontFamily: GlobalLabel.typeLetterTitle,
            ),
          ),
        )
      ],
    ).show();
  }

  /// Calculate distance between two points
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371;
    final double lat1Rad = math.radians(lat1);
    final double lon1Rad = math.radians(lon1);
    final double lat2Rad = math.radians(lat2);
    final double lon2Rad = math.radians(lon2);

    final double latDiff = lat2Rad - lat1Rad;
    final double lonDiff = lon2Rad - lon1Rad;
    final double a = sin(latDiff / 2) * sin(latDiff / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(lonDiff / 2) * sin(lonDiff / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = earthRadius * c;

    return distance * 1000;
  }

  /// Check hour day
  /// Result true: Is day
  /// Result false: Is night
  checkHourDay() {
    String timeDay = "06:00";
    String timeNight = "18:00";
    int hourDay = int.parse(timeDay.split(":")[0]);
    int minuteDay = int.parse(timeDay.split(":")[1]);
    int hourNight = int.parse(timeNight.split(":")[0]);
    int minuteNight = int.parse(timeNight.split(":")[1]);
    int hora =
        ((DateFormat.jm().toString().split(' ')[1].toUpperCase() == "PM" &&
                hourNow < 12)
            ? 12 + hourNow
            : hourNow);
    int minute = minuteNow;
    if ((hora == hourDay && minute >= minuteDay)) {
      return true;
    } else if ((hora == hourDay && minute < minuteDay) ||
        (hora == hourNight && minute >= minuteNight)) {
      return false;
    } else if (hora >= hourDay && hora <= hourNight) {
      return true;
    } else {
      return false;
    }
  }

  /// Open app google maps
  void openGoogleMaps(double latitude, double longitude) async {
    var backUrl = '';
    if (Platform.isAndroid) {
      backUrl = 'google.navigation:q=$latitude,$longitude&mode=a';
    } else {
      backUrl =
          'comgooglemaps://?saddr=&daddr=$latitude,$longitude&directionsmode=driving';
    }
    try {
      bool launched = false;
      if (!launched) {
        await launchUrl(Uri.parse(backUrl));
      }
    } catch (e) {
      await launchUrl(Uri.parse(backUrl));
    }
  }

  /// Open app waze
  void openWaze(double latitude, double longitude) async {
    var backUrl =
        'https://waze.com/ul?ll=${latitude.toString()},${longitude.toString()}&navigate=yes';
    try {
      bool launched = false;
      if (!launched) {
        await launchUrl(Uri.parse(backUrl));
      }
    } catch (e) {
      await launchUrl(Uri.parse(backUrl));
    }
  }

  /// Dial call
  void dialCall(String numberPhone) async {
    if (!await launchUrl(
      Uri.parse('tel:$numberPhone'),
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $numberPhone';
    }
  }

  /// Format date gain day
  formatDateGainDay(String? dateServer) {
    if (dateServer == null || dateServer.isEmpty) return '';
    var dateRegister = dateServer.split(' ');
    var format = dateRegister[0].split('-');
    if (format[1] == '01') {
      return '${format[2]} ${GlobalLabel.textJanuary}. ${format[0]}';
    } else if (format[1] == '02') {
      return '${format[2]} ${GlobalLabel.textFebruary}. ${format[0]}';
    } else if (format[1] == '03') {
      return '${format[2]} ${GlobalLabel.textMarch}. ${format[0]}';
    } else if (format[1] == '04') {
      return '${format[2]} ${GlobalLabel.textApril}. ${format[0]}';
    } else if (format[1] == '05') {
      return '${format[2]} ${GlobalLabel.textMay}. ${format[0]}';
    } else if (format[1] == '06') {
      return '${format[2]} ${GlobalLabel.textJunie}. ${format[0]}';
    } else if (format[1] == '07') {
      return '${format[2]} ${GlobalLabel.textJuly}. ${format[0]}';
    } else if (format[1] == '08') {
      return '${format[2]} ${GlobalLabel.textAugust}. ${format[0]}';
    } else if (format[1] == '09') {
      return '${format[2]} ${GlobalLabel.textSeptember}. ${format[0]}';
    } else if (format[1] == '10') {
      return '${format[2]} ${GlobalLabel.textOctober}. ${format[0]}';
    } else if (format[1] == '11') {
      return '${format[2]} ${GlobalLabel.textNovember}. ${format[0]}';
    } else if (format[1] == '12') {
      return '${format[2]} ${GlobalLabel.textDecember}. ${format[0]}';
    }
  }

  /// Format date
  formatDate() {
    var format = date.format(dateNow).split('-');
    if (format[1] == '01') {
      return '${format[2]} ${GlobalLabel.textJanuary}. ${format[0]}';
    } else if (format[1] == '02') {
      return '${format[2]} ${GlobalLabel.textFebruary}. ${format[0]}';
    } else if (format[1] == '03') {
      return '${format[2]} ${GlobalLabel.textMarch}. ${format[0]}';
    } else if (format[1] == '04') {
      return '${format[2]} ${GlobalLabel.textApril}. ${format[0]}';
    } else if (format[1] == '05') {
      return '${format[2]} ${GlobalLabel.textMay}. ${format[0]}';
    } else if (format[1] == '06') {
      return '${format[2]} ${GlobalLabel.textJunie}. ${format[0]}';
    } else if (format[1] == '07') {
      return '${format[2]} ${GlobalLabel.textJuly}. ${format[0]}';
    } else if (format[1] == '08') {
      return '${format[2]} ${GlobalLabel.textAugust}. ${format[0]}';
    } else if (format[1] == '09') {
      return '${format[2]} ${GlobalLabel.textSeptember}. ${format[0]}';
    } else if (format[1] == '10') {
      return '${format[2]} ${GlobalLabel.textOctober}. ${format[0]}';
    } else if (format[1] == '11') {
      return '${format[2]} ${GlobalLabel.textNovember}. ${format[0]}';
    } else if (format[1] == '12') {
      return '${format[2]} ${GlobalLabel.textDecember}. ${format[0]}';
    }
  }

  /// Format hour
  formatHour() {
    var format = hour.format(dateNow);
    return format;
  }

  /// Show no result
  Widget noResult(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const CircleAvatar(
          //   radius: 50,
          //   backgroundImage:
          //       AssetImage('${GlobalLabel.directionImageInternal}ghost.gif'),
          // ),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            child: Image.asset(
              '${GlobalLabel.directionImageInternal}ghost.gif',
              cacheWidth: 131,
              cacheHeight: 131,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const CircleAvatar(
                  radius: 23.0,
                  backgroundColor: GlobalColors.colorBackgroundView,
                  child: Icon(Icons.person,
                      size: 35.0, color: GlobalColors.colorWhite),
                );
              },
              width: 104,
              height: 104,
            ),
          ),
          const SizedBox(height: 20),
          WidgetTextFieldSubTitle(title: message, align: TextAlign.center)
        ],
      ),
    );
  }

  /// Format hour history
  formatHourHistory(String hourHistory) {
    String hour = '';
    var data = hourHistory.split(':');
    hour = '${data[0]}:${data[1]}';
    return hour;
  }

  /// Format accuracy GPS
  formatAccuracyGPS(double accuracy) {
    int totalAccuracy = 0;
    if (accuracy <= 50) {
      totalAccuracy = 1;
    } else if (accuracy >= 51 && accuracy <= 100) {
      totalAccuracy = 2;
    } else if (accuracy >= 101 && accuracy <= 250) {
      totalAccuracy = 3;
    } else if (accuracy >= 251 && accuracy <= 500) {
      totalAccuracy = 4;
    } else if (accuracy >= 501 && accuracy <= 650) {
      totalAccuracy = 5;
    } else if (accuracy >= 651 && accuracy <= 1000) {
      totalAccuracy = 6;
    } else if (accuracy >= 1001 && accuracy <= 2000) {
      totalAccuracy = 7;
    } else if (accuracy >= 2001 && accuracy <= 4000) {
      totalAccuracy = 8;
    } else if (accuracy >= 4001) {
      totalAccuracy = 9;
    }
    return totalAccuracy;
  }

  /// Different hour
  differentHour(String hourInitial, String hourFinish) {
    int sumH = 0, sumM = 0;
    var hourIni = hourInitial.split(":");
    int hI = int.parse(hourIni[0]);
    int mI = int.parse(hourIni[1]);

    var hourFin = hourFinish.split(":");
    int hF = int.parse(hourFin[0]);
    int mF = int.parse(hourFin[1]);

    int addTime = (hI - hF) < 0 ? (hI - hF) * -1 : hI - hF;
    int addMinute = (mI - mF) < 0 ? (mI - mF) * -1 : mI - mF;

    if (addTime > 24) {
      sumH = addTime - 24;
      if (addMinute >= 60) {
        sumM = addMinute - 60;
        sumH = addTime + 1;
      }
      return '${(sumH < 10) ? '0$sumH' : sumH}:${(sumM < 10) ? '0$sumM' : sumM}:${hourIni[2]}';
    } else if (addMinute >= 60) {
      sumM = addMinute - 60;
      sumH = addTime + 1;
      return '${(sumH < 10) ? '0$sumH' : sumH}:${(sumM < 10) ? '0$sumM' : sumM}:${hourIni[2]}';
    } else {
      return '${(addTime < 10) ? '0$addTime' : addTime}:${(addMinute < 10) ? '0$addMinute' : addMinute}:${hourIni[2]}';
    }
  }

  /// Hide query
  void hideQuery() {
    FocusScope.of(GlobalFunction.context.currentContext!)
        .requestFocus(FocusNode());
  }

  /// Open camera
  /// Type 1: Chat request
  /// Type 2: Report anomaly
  void openCamera(int type) async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    File fileImage = File(image!.path);
    compressFile(GlobalFunction.context.currentContext!, fileImage, type);
  }

  /// Compress File
  void compressFile(BuildContext context, File file, type) async {
    final prReportAnomalyRead = context.read<ProviderReportAnomaly>();
    final prChatRequestRead = context.read<ProviderChatRequest>();
    final prVerifyIdentityRead = context.read<ProviderVerifyIdentity>();

    await FlutterImageCompress.compressAndGetFile(
      file.path,
      file.path.replaceAll('.jpg', '_compressed.jpg'),
      minHeight: 1920,
      minWidth: 1080,
      quality: 70,
    ).then((result) {
      if (result == null) return;
      if (type == 1) {
        prChatRequestRead.addImage(File(result.path));
      } else if (type == 2) {
        prReportAnomalyRead.addImage(File(result.path));
      } else {
        prVerifyIdentityRead.detectedImage(File(result.path));
      }
    });
  }

  /// Open gallery
  /// Type 1: Chat request
  /// Type 2: Report anomaly
  void openGallery(int type) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    File fileImage = File(image!.path);
    compressFile(GlobalFunction.context.currentContext!, fileImage, type);
  }

  /// Get image driver
  Widget getImageDriver(int type, String url, double size, double radio) {
    return url.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(radio)),
            child: FadeInImage.assetNetwork(
                placeholder: '${GlobalLabel.directionImageInternal}lisa.png',
                image: url,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  return const CircleAvatar(
                    radius: 23.0,
                    backgroundColor: GlobalColors.colorBackgroundView,
                    child: Icon(Icons.person,
                        size: 35.0, color: GlobalColors.colorWhite),
                  );
                },
                width: size,
                height: size))
        : const CircleAvatar(
            radius: 23.0,
            backgroundColor: GlobalColors.colorBackgroundView,
            child:
                Icon(Icons.person, size: 35.0, color: GlobalColors.colorWhite),
          );
  }

  /// Background image view
  Widget backgroundImage() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(3),
      height: MediaQuery.of(GlobalFunction.context.currentContext!).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image:
              AssetImage("${GlobalLabel.directionImageInternal}fondochat.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// Quit focus text field
  void deleteFocusForm() {
    FocusManager.instance.primaryFocus!.unfocus();
  }

  /// Format date transaction
  formatDateServe(String dateTransaction) {
    var dateRegister = dateTransaction.split(' ');
    var format = dateRegister[0].split('-');
    if (format[1] == '01') {
      return '${format[2]} ${GlobalLabel.textJanuary}. ${dateRegister[1]}';
    } else if (format[1] == '02') {
      return '${format[2]} ${GlobalLabel.textFebruary}. ${dateRegister[1]}';
    } else if (format[1] == '03') {
      return '${format[2]} ${GlobalLabel.textMarch}. ${dateRegister[1]}';
    } else if (format[1] == '04') {
      return '${format[2]} ${GlobalLabel.textApril}. ${dateRegister[1]}';
    } else if (format[1] == '05') {
      return '${format[2]} ${GlobalLabel.textMay}. ${dateRegister[1]}';
    } else if (format[1] == '06') {
      return '${format[2]} ${GlobalLabel.textJunie}. ${dateRegister[1]}';
    } else if (format[1] == '07') {
      return '${format[2]} ${GlobalLabel.textJuly}. ${dateRegister[1]}';
    } else if (format[1] == '08') {
      return '${format[2]} ${GlobalLabel.textAugust}. ${dateRegister[1]}';
    } else if (format[1] == '09') {
      return '${format[2]} ${GlobalLabel.textSeptember}. ${dateRegister[1]}';
    } else if (format[1] == '10') {
      return '${format[2]} ${GlobalLabel.textOctober}. ${dateRegister[1]}';
    } else if (format[1] == '11') {
      return '${format[2]} ${GlobalLabel.textNovember}. ${dateRegister[1]}';
    } else if (format[1] == '12') {
      return '${format[2]} ${GlobalLabel.textDecember}. ${dateRegister[1]}';
    }
  }

  /// Open google play
  void openGooglePlay() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final appId = Platform.isAndroid
          ? (await PackageInfo.fromPlatform()).packageName
          : 'YOUR_IOS_APP_ID';
      final url = Uri.parse(
        Platform.isAndroid
            ? "market://details?id=$appId"
            : "https://apps.apple.com/app/id$appId",
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    }
  }

  /// Open google play
  void openPageOwner() async {
    final Uri url = Uri.parse('https://kradac.com/');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  /// Close view active
  void closeView() {
    Navigator.pop(GlobalFunction.context.currentContext!);
  }

  /// Design chat audio
  Widget designChatAudio(bool playAudio) {
    return AudioWave(
      height: 10,
      width:
          MediaQuery.of(GlobalFunction.context.currentContext!).size.width / 2,
      spacing: 7,
      animationLoop: 1,
      animation: false,
      beatRate: const Duration(milliseconds: 0),
      bars: generateWave(playAudio),
    );
  }

  /// Generate wave chat audio
  generateWave(bool playAudio) {
    Random random = Random();
    List<AudioWaveBar> listWave = [];
    for (int i = 1; i < 20; i++) {
      double number = random.nextDouble();
      number = 0.5 + (number * 0.5);
      listWave.add(AudioWaveBar(
          heightFactor: number,
          color: playAudio
              ? GlobalColors.colorLetterTitle
              : GlobalColors.colorLetterTitle));
    }
    return listWave;
  }

  ///Converter audio to bytes
  getByteAudio(String? path) async {
    Uint8List? bytesSend;
    File file = File(path!);
    if (await file.exists()) {
      Uint8List bytes = file.readAsBytesSync().buffer.asUint8List(
          file.readAsBytesSync().offsetInBytes,
          file.readAsBytesSync().lengthInBytes);
      final forSend = GZipEncoder().encode(bytes);
      bytesSend = Uint8List.fromList(forSend!);
    }
    return bytesSend;
  }

  ///Directory global the audio
  getPathAudio() async {
    final dir = await getExternalStorageDirectory();
    return '${dir!.path}/audio_${DateTime.now().millisecondsSinceEpoch}.mp3';
  }

  /// State player audio assets
  void playAudio(String directionAudio) {
    if (player.state == PlayerState.stopped) {
      player.play(AssetSource(directionAudio));
    }
  }

  /// Path directory audio
  getPathDirectoryAudio(Uint8List? data) async {
    String path = await getPathAudio();
    final bytes = GZipDecoder().decodeBytes(data!);
    Uint8List bytesDecode = Uint8List.fromList(bytes);
    final buffer = bytesDecode.buffer;
    File(path).writeAsBytesSync(buffer.asUint8List(
        bytesDecode.offsetInBytes, bytesDecode.lengthInBytes));
    return path;
  }

  /// Get image notification
  Widget getImageNotification(String url, double size, double radio) {
    return url.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(radio)),
            child: SizedBox(
              height: size,
              width: size,
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: url,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  return const CircleAvatar(
                    radius: 23.0,
                    backgroundColor: GlobalColors.colorWhite,
                    child: Icon(Icons.image,
                        size: 35.0, color: GlobalColors.colorBorder),
                  );
                },
              ),
            ))
        : const CircleAvatar(
            radius: 23.0,
            backgroundColor: GlobalColors.colorBorder,
            child:
                Icon(Icons.image, size: 35.0, color: GlobalColors.colorWhite),
          );
  }

  /// Open link
  openLink(String link) async {
    Uri url;
    url = Uri.parse(link);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  /// Get image url
  Widget getImageURL(String url) {
    return url.isNotEmpty
        ? SizedBox(
            width: double.infinity,
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: url,
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) {
                return const CircleAvatar(
                  radius: 23.0,
                  backgroundColor: GlobalColors.colorWhite,
                  child: Icon(Icons.image,
                      size: 35.0, color: GlobalColors.colorBorder),
                );
              },
            ),
          )
        : const CircleAvatar(
            radius: 23.0,
            backgroundColor: GlobalColors.colorBorder,
            child:
                Icon(Icons.image, size: 35.0, color: GlobalColors.colorWhite),
          );
  }

  /// Initial connection
  Future initialConnection(Connectivity connectivity) async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("ERROR >>> ${e.toString()}");
      }
    }
    return result;
  }

  /// Verify connection real time
  /// Type 1: Send from splash
  /// Type 2: Send from page principal
  updateConnection(ConnectivityResult result) async {
    final prMapRead =
        GlobalFunction.context.currentContext!.read<ProviderMap>();
    final prPrincipalRead =
        GlobalFunction.context.currentContext!.read<ProviderPrincipal>();
    final prPaymentRead =
        GlobalFunction.context.currentContext!.read<ProviderPayment>();
    final prServiceSocketRead =
        GlobalFunction.context.currentContext!.read<ProviderServiceSocket>();
    switch (result) {
      case ConnectivityResult.wifi:
        prServiceSocketRead
            .startConnectionServer(!prPrincipalRead.stateInternet ? 2 : 1);
        prPrincipalRead.stateInternet = true;
        break;
      case ConnectivityResult.mobile:
        prServiceSocketRead
            .startConnectionServer(!prPrincipalRead.stateInternet ? 2 : 1);
        prPrincipalRead.stateInternet = true;
        break;
      case ConnectivityResult.none:
        if (prPaymentRead.showPagePayment) {
          GlobalFunction().closeView();
        }
        prPrincipalRead.stateInternet = false;
        prMapRead.resetTimerTracking();
        break;
      default:
        break;
    }
  }

  void initialApplicative() {
    if (_connectivitySubscription == null) {
      GlobalFunction().initialConnection(_connectivity).then((status) {
        if (status != ConnectivityResult.none) {
          GlobalFunction().verifyVersion().then((status) async {
            if (status.canUpdate!) {
              await GlobalFunction().messageAcceptCancel(
                GlobalLabel.textAppUpdateVersion,
                onWillPop: true,
                () {
                  GlobalFunction().openLink("${status.storeUrl}");
                  SystemNavigator.pop();
                },
                () {
                  SystemNavigator.pop();
                },
              );
            } else {
              _connectivitySubscription =
                  _connectivity.onConnectivityChanged.listen((status) {
                GlobalFunction().updateConnection(status);
              });
            }
          });
        }
      });
    }
  }

  /// Check connection
  Future checkConnection() async {
    bool state = false;
    try {
      final response = await http.head(Uri.parse('https://www.google.com'));
      if (response.statusCode == 200) {
        state = true;
      } else {
        state = false;
      }
    } on SocketException catch (_) {
      state = false;
    }
    return state;
  }

  /// Check connection server
  Future<bool> checkConnectionServer() async {
    bool state = false;
    try {
      final response = await http.head(Uri.parse(GlobalLabel.ipConnection));
      if (response.statusCode == 200) {
        state = true;
      } else {
        state = false;
      }
    } catch (e) {
      state = false;
    }
    return state;
  }

  /// Get image background in the view
  Widget imageBackground() {
    return Container(
      margin: const EdgeInsets.only(top: 3),
      child: Image.asset(
        '${GlobalLabel.directionImageInternal}fondo.png',
        height:
            MediaQuery.of(GlobalFunction.context.currentContext!).size.height,
        width: MediaQuery.of(GlobalFunction.context.currentContext!).size.width,
        fit: BoxFit.cover,
      ),
    );
  }

  /// Format distance
  String formatDistance(double distance) {
    String result = '';
    double operation;
    if (distance >= 1000) {
      operation = distance / 1000;
      result = '${operation.roundToDouble().toInt()}';
    } else {
      result = '${distance.toInt()}';
    }
    return result;
  }

  void styleMap() async {
    final prMapRead =
        GlobalFunction.context.currentContext!.read<ProviderMap>();
    String styleMap =
        await rootBundle.loadString('${GlobalLabel.typeMap}style_map_day.json');

    if (!GlobalFunction().checkHourDay()) {
      styleMap = await rootBundle
          .loadString('${GlobalLabel.typeMap}style_map_night.json');
    }
    prMapRead.mapController.setMapStyle(styleMap);
  }

  /// Format the typed price
  formatPrice(String previous, String current) {
    String data;
    String result;
    String cost;
    String value;

    if (previous == '0.00') {
      data = current;
    } else {
      String dateBefore;
      if (previous.contains('.')) {
        dateBefore = previous.replaceAll('.', '');
      } else {
        dateBefore = previous;
      }
      data = '$dateBefore$current';
    }
    result = data.toString().substring(0, data.toString().length);
    if (result.toString().length == 1) {
      cost = '0.0$result';
    } else if (result.toString().length == 2) {
      result = '0$result';
      cost =
          '${result.toString().substring(0, result.toString().length - 2)}.${result.toString().substring(result.toString().length - 2, result.toString().length)}';
    } else if (result.toString().length > 2) {
      if (result.toString()[0] == '0') {
        result = result.substring(1, result.length);
      }
      cost = result;
      cost = cost.toString().replaceAll('.', '');
      cost =
          "${cost.substring(0, cost.length - 2)}.${cost.substring(cost.length - 2, cost.length)}";
    } else {
      cost = current;
    }
    value = '';
    value = cost;
    return value.toString();
  }

  /// Format reason register
  reasonRegister(String selectedCountry, String selectedCity, String referred,
      String hashtag, String commentary) {
    StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write('$hashtag | $commentary | ');
    stringBuffer.write('Pais: $selectedCountry | ');
    stringBuffer.write('Ciudad: $selectedCountry | ');
    stringBuffer.write('Referido: ${referred.toUpperCase()}');
    return stringBuffer.toString();
  }

  /// Show wait progress
  void showProgress() {
    GlobalFunction().nextPageViewTransition(const WidgetProgress());
  }

  /// Hide wait progress
  hideProgress() {
    if (Navigator.canPop(GlobalFunction.context.currentContext!)) {
      Navigator.pop(GlobalFunction.context.currentContext!);
    }
  }

  /// Message error Dio
  void messageErrorDio(dynamic e, String url) {
    if (e.response != null) {
      if (kDebugMode) {
        print(
            'ERROR >>> REST ${e.response!.statusCode} - ${e.response!.data} - $url');
      }
    }
  }

  Future checkPermissionBubble(BuildContext context) async {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    prPrincipalRead.statusHasPermissionBubble =
        await DashBubble.instance.requestOverlayPermission();
    prPrincipalRead.statusIsGrantedBubble =
        await DashBubble.instance.hasOverlayPermission();
  }

  Future startBubble(BuildContext context) async {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    if (prPrincipalRead.statusHasPermissionBubble &&
        prPrincipalRead.statusIsGrantedBubble) {
      DashBubble.instance.startBubble(
          bubbleOptions: BubbleOptions(
            bubbleIcon: 'ic_bubble',
            startLocationY: 100,
            startLocationX: 0,
            bubbleSize: 60,
            opacity: 1,
            enableClose: true,
            closeBehavior: CloseBehavior.following,
            distanceToClose: 100,
            enableAnimateToEdge: true,
            enableBottomShadow: true,
            keepAliveWhenAppExit: false,
          ),
          notificationOptions: NotificationOptions(
            icon: 'ic_bubble',
          ),
          onTap: () {
            FlutterForegroundTask.launchApp();
            stopBubble();
          });
    }
  }

  void stopBubble() async {
    if (await DashBubble.instance.isRunning()) {
      DashBubble.instance.stopBubble();
    }
  }

  int checkDistance() {
    final prMapRead =
        GlobalFunction.context.currentContext!.read<ProviderMap>();
    final prPrincipalRead =
        GlobalFunction.context.currentContext!.read<ProviderPrincipal>();
    double distanceInMeters = geo.Geolocator.distanceBetween(
      prMapRead.positionLatitude,
      prMapRead.positionLongitude,
      prPrincipalRead.modelRequestActive!.requestData!.latitude!,
      prPrincipalRead.modelRequestActive!.requestData!.longitude!,
    );
    return int.parse(distanceInMeters.toStringAsFixed(0));
  }

  void proximityNotice() {
    final prPrincipalRead =
        GlobalFunction.context.currentContext!.read<ProviderPrincipal>();
    if (prPrincipalRead.modelRequestActive!.requestData != null &&
        prPrincipalRead.modelRequestActive!.statusDriver == 3 &&
        !prPrincipalRead.proximityNotice) {
      if (GlobalFunction().checkDistance() <= 20) {
        if (prPrincipalRead.modelRequestActive!.requestData!.user!.addresses![3]
                .description ==
            "") {
          GlobalFunction().speakMessage(GlobalLabel.textMessageArrived);
        } else {
          GlobalFunction().speakMessage(
              "${GlobalLabel.textMessageArrivedReference} ${prPrincipalRead.modelRequestActive!.requestData!.user!.addresses![3].description}");
        }
        prPrincipalRead.proximityNotice = true;
      }
    }
  }

  sendMoreTime(BuildContext context) {
    final prServiceSocketsRead = context.read<ProviderServiceSocket>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    if (prPrincipalRead.modelRequestActive!.statusDriver == 3 &&
        prPrincipalRead.modelRequestActive!.requestData!.advice == 0) {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: GlobalFunction.context.currentContext!,
        builder: (context) => Container(
          margin: const EdgeInsets.only(top: 10.0),
          child: Material(
            color: Colors.transparent,
            child: SafeArea(
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) =>
                    Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: GlobalColors.colorWhite,
                    border: Border.all(
                      width: .2,
                      color: GlobalColors.colorBorder,
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: 10.0, left: 15.0, right: 15.0, bottom: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const WidgetTextFieldPersonalized(
                              size: 20,
                              color: GlobalColors.colorLetterTitle,
                              type: 1,
                              title: GlobalLabel.textAlertFinishTime,
                              align: TextAlign.center),
                          const SizedBox(height: 10),
                          const WidgetTextFieldSubTitle(
                              title: GlobalLabel.textDescriptionAlertFinishTime,
                              align: TextAlign.left),
                          const SizedBox(height: 30),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: Center(
                              child: SizedBox(
                                width:
                                    (50 + 5 + 5) * optionTime.length.toDouble(),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: optionTime.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        prServiceSocketsRead.sendChat(
                                          1,
                                          1,
                                          '${GlobalLabel.textMessageAlertFinishTime} ${optionTime[index]} ${GlobalLabel.textMinutes.toLowerCase()}',
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0)),
                                          color: GlobalColors.colorButton,
                                          border: Border.all(
                                              width: .8,
                                              color: GlobalColors.colorBorder),
                                          boxShadow: [
                                            BoxShadow(
                                              color: GlobalColors.colorBorder
                                                  .withOpacity(.5),
                                              blurRadius: 5.0,
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: WidgetTextFieldPersonalized(
                                          type: 1,
                                          color: GlobalColors.colorWhite,
                                          size: 16,
                                          title: optionTime[index],
                                          align: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      return null;
    }
  }

  Future<BitmapDescriptor> createMarker(String urlAssets) async {
    final Uint8List markerIcon = await getBytesFromAsset(urlAssets, 130);
    return BitmapDescriptor.fromBytes(markerIcon);
  }

  static Future<Uint8List> getBytesFromAsset(String path, int? width) async {
    ByteData? data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
  }

  String byteListToHex(List<int> bytes) {
    String result = '';
    for (int i = 0; i < bytes.length; i++) {
      result += (bytes[i] & 0xff).toRadixString(16).padLeft(2, '0');
    }
    return result;
  }

  String totalTravel(int numTravel) {
    if (numTravel < 1000) {
      return numTravel.toString();
    } else if (numTravel < 10000) {
      double result = numTravel / 1000.0;
      return '${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)}k';
    } else if (numTravel < 1000000) {
      double result = numTravel / 1000.0;
      return '${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)}k';
    } else if (numTravel < 10000000) {
      double result = numTravel / 1000000.0;
      return '${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)}M';
    } else {
      return numTravel.toString();
    }
  }

  configurationTaximeter(BuildContext context) {
    final prPrincipalRead = context.read<ProviderPrincipal>();
    final prTaximeterRead = context.read<ProviderTaximeter>();
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: GlobalFunction.context.currentContext!,
      builder: (context) => Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) =>
                  Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: GlobalColors.colorWhite,
                  border: Border.all(
                    width: .2,
                    color: GlobalColors.colorBorder,
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(
                      top: 10.0, left: 15.0, right: 15.0, bottom: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const WidgetTextFieldTitle(
                            title: GlobalLabel.textConfigurationTaximeter,
                            align: TextAlign.left),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            WidgetContainer(
                              color: GlobalColors.colorWhite,
                              widget: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: WidgetTextFieldSubTitle(
                                            title: GlobalLabel.textHourInitial,
                                            align: TextAlign.left),
                                      ),
                                      Expanded(
                                        flex: 0,
                                        child: WidgetTextFieldTitle(
                                            title: prPrincipalRead
                                                .modelRequestActive!
                                                .requestData!
                                                .hour!,
                                            align: TextAlign.left),
                                      ),
                                    ],
                                  ),
                                  const WidgetDivider(),
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: WidgetTextFieldSubTitle(
                                            title: GlobalLabel
                                                .textDistanceTraveled,
                                            align: TextAlign.left),
                                      ),
                                      Expanded(
                                        flex: 0,
                                        child: WidgetTextFieldTitle(
                                            title:
                                                '${prTaximeterRead.distanceTraveled.toStringAsFixed(2)} ${prTaximeterRead.unitMeasure}',
                                            align: TextAlign.left),
                                      )
                                    ],
                                  ),
                                  const WidgetDivider(),
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: WidgetTextFieldSubTitle(
                                            title: GlobalLabel.textValueInitial,
                                            align: TextAlign.left),
                                      ),
                                      Expanded(
                                          flex: 0,
                                          child: WidgetTextFieldTitle(
                                              title: GlobalFunction()
                                                      .checkHourDay()
                                                  ? '${prTaximeterRead.taximeter.aD!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}'
                                                  : '${prTaximeterRead.taximeter.aN!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                                              align: TextAlign.left)),
                                    ],
                                  ),
                                  const WidgetDivider(),
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: WidgetTextFieldSubTitle(
                                            title: GlobalLabel.textMinimalCost,
                                            align: TextAlign.left),
                                      ),
                                      Expanded(
                                          flex: 0,
                                          child: WidgetTextFieldTitle(
                                              title: GlobalFunction()
                                                      .checkHourDay()
                                                  ? '${prTaximeterRead.taximeter.cD!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}'
                                                  : '${prTaximeterRead.taximeter.cN!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                                              align: TextAlign.left)),
                                    ],
                                  ),
                                  const WidgetDivider(),
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: WidgetTextFieldSubTitle(
                                            title: GlobalLabel.textCostDistance,
                                            align: TextAlign.left),
                                      ),
                                      Expanded(
                                          flex: 0,
                                          child: WidgetTextFieldTitle(
                                              title: GlobalFunction()
                                                      .checkHourDay()
                                                  ? '${prTaximeterRead.taximeter.kmD!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}'
                                                  : '${prTaximeterRead.taximeter.kmN!.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                                              align: TextAlign.left))
                                    ],
                                  ),
                                  const WidgetDivider(),
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: WidgetTextFieldSubTitle(
                                            title: GlobalLabel.textTimeTotal,
                                            align: TextAlign.left),
                                      ),
                                      Expanded(
                                        flex: 0,
                                        child: WidgetTextFieldTitle(
                                            title:
                                                '${GlobalFunction().differentHour(prPrincipalRead.modelRequestActive!.requestData!.hour!, GlobalFunction().hour.format(GlobalFunction().dateNow))}',
                                            align: TextAlign.left),
                                      )
                                    ],
                                  ),
                                  const WidgetDivider(),
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: WidgetTextFieldSubTitle(
                                            title: GlobalLabel.textTimeWait,
                                            align: TextAlign.left),
                                      ),
                                      Expanded(
                                        flex: 0,
                                        child: WidgetTextFieldTitle(
                                            title:
                                                '${prTaximeterRead.timeTotalWait} - ${prTaximeterRead.costTimeWait.toStringAsFixed(2)} ${prPrincipalRead.nameMoney}',
                                            align: TextAlign.left),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return null;
  }

  String colorRandom() {
    Options options = Options(
        format: Format.hex,
        colorType: [
          ColorType.green,
          ColorType.blue,
          ColorType.purple,
          ColorType.orange
        ],
        luminosity: Luminosity.dark);
    var color = RandomColor.getColor(options);
    return color;
  }

  Future verifyVersion() async {
    AppVersionResult status = AppVersionResult();
    await AppVersionUpdate.checkForUpdates(
      appleId: GlobalLabel.appleId,
      playStoreId: GlobalLabel.playStoreId,
      country: 'ec',
    ).then((result) async {
      status = result;
    });
    return status;
  }
}
