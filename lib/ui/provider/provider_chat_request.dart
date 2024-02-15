import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart' as audio;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/response/response_message_chat.dart';
import '../../domain/entities/model_data_emit.dart';
import '../../domain/entities/model_message_chat.dart';
import '../../domain/entities/model_request.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_preference.dart';
import 'provider_configuration_app.dart';
import 'provider_principal.dart';
import 'provider_service/provider_service_rest.dart';

class ProviderChatRequest with ChangeNotifier {
  TextEditingController editChat = TextEditingController();
  List<Chat>? listMessage = [];
  int? _countChat = 0;
  bool? _typeChat = false;
  String? _messageChatUser = '';
  bool? _isRecording = false;
  RecorderController? _recorderController = RecorderController();
  String? _pathAudio;
  ScrollController? controller = ScrollController();
  audio.AudioPlayer? audioPlayerChat = audio.AudioPlayer();
  int? _indexAudioPlaying = 0;
  ModelDataEmit? _dataEmit;
  String? _coverChatHour;
  List<ModelMessageChat>? optionChat = [];

  String get coverChatHour => _coverChatHour!;

  set coverChatHour(String value) {
    _coverChatHour = value;
    notifyListeners();
  }

  ModelDataEmit get dataEmit => _dataEmit!;

  set dataEmit(ModelDataEmit value) {
    _dataEmit = value;
  }

  int get indexAudioPlaying => _indexAudioPlaying!;

  set indexAudioPlaying(int value) {
    _indexAudioPlaying = value;
  }

  String get messageChatUser => _messageChatUser!;

  set messageChatUser(String value) {
    _messageChatUser = value;
  }

  bool get typeChat => _typeChat!;

  set typeChat(bool value) {
    _typeChat = value;
    notifyListeners();
  }

  int get countChat => _countChat!;

  set countChat(int value) {
    _countChat = value;
  }

  String? get pathAudio => _pathAudio!;

  set pathAudio(String? value) {
    _pathAudio = value;
  }

  RecorderController get recorderController => _recorderController!;

  set recorderController(RecorderController value) {
    _recorderController = value;
  }

  bool get isRecording => _isRecording!;

  set isRecording(bool value) {
    _isRecording = value;
  }

  void deleteListChat() {
    listMessage!.clear();
    _countChat = 0;
    notifyListeners();
  }

  /// Type message
  /// typeChat 1: Text
  /// typeChat 2: Image
  /// typeChat 3: Video
  /// typeChat 4: Audio
  void addMessageListChat(String message, String uid, int typeChat) {
    final prConfigurationAppRead =
        GlobalFunction.context.currentContext!.read<ProviderConfigurationApp>();
    Chat chat = Chat();
    chat.stateChat = false;
    chat.message = message;
    chat.typeChat = typeChat;
    chat.uid = uid;
    chat.hour = GlobalFunction().hour.format(GlobalFunction().dateNow);
    chat.date = GlobalFunction().date.format(GlobalFunction().dateNow);
    chat.isPlaying = false;
    listMessage!.add(chat);
    switch (typeChat) {
      case 1:
        _messageChatUser = message;
        if (prConfigurationAppRead.modelConfigurationApp.speakChat! &&
            uid == '124') {
          GlobalFunction()
              .speakMessage('${GlobalLabel.textSpeakChat}, $message');
        }
        break;
    }
    GlobalFunction().playAudio(GlobalLabel.sendChat);
    GlobalPreference().setChatRequest(listMessage!);
    badgeChat();
    notifyListeners();
    moveScrollController();
  }

  void moveScrollController() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (controller != null && controller!.hasClients) {
      controller?.animateTo((controller?.position.maxScrollExtent ?? 0) + 150,
          curve: Curves.decelerate,
          duration: const Duration(milliseconds: 300));
    }
  }

  /// Badge notification new chat
  void badgeChat() {
    _countChat = 0;
    if (listMessage!.isEmpty) return;
    for (Chat chat in listMessage!) {
      if (chat.uid == '124' && !chat.stateChat!) {
        _countChat = _countChat! + 1;
      }
    }
    notifyListeners();
  }

  /// Delete badge chat
  void deleteBadgeChat() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _countChat = 0;
    notifyListeners();
  }

  /// Set view chat
  void updateViewChat() async {
    initialiseControllers();
    await Future.delayed(const Duration(milliseconds: 300));
    if (listMessage!.isEmpty) return;
    for (Chat chat in listMessage!) {
      chat.stateChat = true;
    }
    notifyListeners();
  }

  /// Get audio chat user
  void getAudioOld(dynamic data) async {
    if (data != null) {
      var path = await GlobalFunction().getPathDirectoryAudio(data);
      if (File(path).lengthSync() == 0) return;
      _messageChatUser = GlobalLabel.textUserChatAudio;

      addMessageListChat('', '124', 4);
      GlobalFunction().playAudio(GlobalLabel.directionAudio);
    }
  }

  /// Initial controller record chat type audio
  void initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }

  /// Initial audio player
  void initialAudioPlayer() {
    audioPlayerChat!.onPlayerStateChanged.listen((audio.PlayerState state) {
      if (state == audio.PlayerState.playing) {
        updateIsPlaying(true);
      } else {
        updateIsPlaying(false);
      }
    }, onError: (msg) {
      if (kDebugMode) {
        print('ERROR CHAT AUDIO WALKIES TALKIE: $msg');
      }
    });
  }

  /// Update state isPlaying chat
  void updateIsPlaying(bool state) {
    listMessage![_indexAudioPlaying!].isPlaying = state;
    notifyListeners();
  }

  /// Start recording audio
  void startOrStopRecording(BuildContext context) async {
    final prServiceRestRead = context.read<ProviderServiceRest>();
    final prPrincipalRead = context.read<ProviderPrincipal>();
    try {
      if (isRecording) {
        final path = await recorderController.stop(false);
        if (recorderController.recordedDuration > const Duration(seconds: 1)) {
          if (path != null && File(path).lengthSync() != 0) {
            prServiceRestRead.sendFileRequest(
                path,
                prPrincipalRead.modelRequestActive!.requestData!.requestId!,
                prPrincipalRead.modelUser.idUser!,
                prPrincipalRead
                    .modelRequestActive!.requestData!.user!.clientId!,
                1);
            // var byteAudio = await GlobalFunction().getByteAudio(path);
            // prServiceSocketsRead.sendChatAudio(byteAudio);
          }
        }
      } else {
        _pathAudio = await GlobalFunction().getPathAudio();
        if (_pathAudio == null || _pathAudio!.isEmpty) return;
        await recorderController.record(path: _pathAudio!);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isRecording = !isRecording;
      notifyListeners();
    }
  }

  /// Add chat type image
  void addImage(File photo) async {
    addMessageListChat('Image', '123', 2);
    GlobalFunction().playAudio(GlobalLabel.sendChat);
  }

  /// State player audio chat
  void playAudioChat(String directionAudio) {
    audioPlayerChat!.play(audio.UrlSource(directionAudio));
    // audioPlayerChat!.play(audio.DeviceFile/source(directionAudio));
  }

  void listMessageChat(ResponseMessageChat responseMessageChat) {
    if (optionChat!.isNotEmpty) optionChat!.clear();
    optionChat!.addAll(responseMessageChat.data!);
    notifyListeners();
  }
}
