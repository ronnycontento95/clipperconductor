import 'dart:io';

import 'package:audioplayers/audioplayers.dart' as audio;
import 'package:audio_waveforms/audio_waveforms.dart' as audio_wave;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/model_data_emit.dart';
import '../../domain/entities/model_request.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import '../util/global_preference.dart';
import 'provider_service/provider_service_socket.dart';

class ProviderWalkiesTalkie extends ChangeNotifier {
  bool? _isRecording = false;
  int? _positionSelectedRequest = 1;
  final ScrollController scrollControllerList = ScrollController();
  List<Chat> listFilterChatAudioBusiness = [];
  List<Chat> listFilterChatAudioCallCenter = [];
  List<Chat> listFilterChatAudioAllDriver = [];
  audio.AudioPlayer? audioPlayerChat = audio.AudioPlayer();
  int? _indexAudioPlaying = 0;
  List<Chat>? listChatAudio = [];
  audio_wave.RecorderController? _recorderController;
  bool? _isRecordingCompleted = false;
  String? _pathAudio;
  audio.AudioPlayer playerChat = audio.AudioPlayer();
  bool? _showChatAudio = false;
  ModelDataEmit? _dataEmitChat;

  ModelDataEmit? get dataEmitChat => _dataEmitChat;

  set dataEmitChat(ModelDataEmit? value) {
    if (value != null) {
      _dataEmitChat = value;
    }
  }

  bool get showChatAudio => _showChatAudio!;

  set showChatAudio(bool value) {
    _showChatAudio = value;
    notifyListeners();
  }

  String get pathAudio => _pathAudio!;

  set pathAudio(String value) {
    _pathAudio = value;
  }

  bool get isRecordingCompleted => _isRecordingCompleted!;

  set isRecordingCompleted(bool value) {
    _isRecordingCompleted = value;
  }

  int get indexAudioPlaying => _indexAudioPlaying!;

  set indexAudioPlaying(int value) {
    _indexAudioPlaying = value;
  }

  int get positionSelectedRequest => _positionSelectedRequest!;

  set positionSelectedRequest(int value) {
    _positionSelectedRequest = value;
  }

  bool get isRecording => _isRecording!;

  set isRecording(bool value) {
    _isRecording = value;
  }

  /// Initial audio player
  void initialAudioPlayer() {
    audioPlayerChat!.onPlayerStateChanged.listen((audio.PlayerState state) {
      if (state == audio.PlayerState.playing) {
        updateIsPlaying(true);
      } else {
        updateIsPlaying(false);
      }
      updateViewChatAudio(_indexAudioPlaying!);
    }, onError: (msg) {
      if (kDebugMode) {
        print('ERROR CHAT AUDIO WALKIES TALKIE: $msg');
      }
    });
  }

  /// Initial controller record audio
  void initialiseControllers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _recorderController = audio_wave.RecorderController()
      ..androidEncoder = audio_wave.AndroidEncoder.aac
      ..androidOutputFormat = audio_wave.AndroidOutputFormat.mpeg4
      ..iosEncoder = audio_wave.IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
    notifyListeners();
  }

  /// Update state isPlaying chat
  void updateIsPlaying(bool state) {
    switch (positionSelectedRequest) {
      case 1:
        listFilterChatAudioBusiness[_indexAudioPlaying!].isPlaying = state;
        break;
      case 2:
        listFilterChatAudioCallCenter[_indexAudioPlaying!].isPlaying = state;
        break;
      case 3:
        listFilterChatAudioAllDriver[_indexAudioPlaying!].isPlaying = state;
        break;
    }
    notifyListeners();
  }

  /// Update view chat audio
  void updateViewChatAudio(int index) {
    switch (positionSelectedRequest) {
      case 1:
        listFilterChatAudioBusiness[index].isPlaying = true;
        break;
      case 2:
        listFilterChatAudioCallCenter[index].isPlaying = true;
        break;
      case 3:
        listFilterChatAudioAllDriver[index].isPlaying = true;
        break;
    }
    notifyListeners();
  }

  /// Update state chat audio
  void updateStateViewAudio(int index) async {
    await Future.delayed(const Duration(milliseconds: 300));
    switch (_positionSelectedRequest) {
      case 1:
        if (listFilterChatAudioBusiness.isEmpty) return;
        listFilterChatAudioBusiness[index].stateChat = true;
        break;
      case 2:
        if (listFilterChatAudioCallCenter.isEmpty) return;
        listFilterChatAudioCallCenter[index].stateChat = true;
        break;
      case 3:
        if (listFilterChatAudioAllDriver.isEmpty) return;
        listFilterChatAudioAllDriver[index].stateChat = true;
        break;
    }
    notifyListeners();
  }

  /// State player audio chat
  void playAudioChat(String directionAudio) {
    audioPlayerChat!.play(audio.DeviceFileSource(directionAudio));
  }

  /// Delete filter list chat audio
  void deleteListChatAudio() {
    listFilterChatAudioBusiness.clear();
    listFilterChatAudioCallCenter.clear();
    listFilterChatAudioAllDriver.clear();
    notifyListeners();
  }

  /// Filter chat audio for selected of destiny
  /// TypeAudio 1: Business
  /// TypeAudio 2: Call center
  /// TypeAudio 3: All user driver
  void chatFilterAudio() {
    if (listChatAudio!.isEmpty) return;
    listFilterChatAudioBusiness.addAll(listChatAudio!.reversed.where(
        (element) =>
            (element.pathAudio != null || element.pathAudio!.isEmpty) &&
            element.typeAudioWalkieTalkie == 1));
    listFilterChatAudioCallCenter.addAll(listChatAudio!.reversed.where(
        (element) =>
            (element.pathAudio != null || element.pathAudio!.isEmpty) &&
            element.typeAudioWalkieTalkie == 2));
    listFilterChatAudioAllDriver.addAll(listChatAudio!.reversed.where(
        (element) =>
            (element.pathAudio != null || element.pathAudio!.isEmpty) &&
            element.typeAudioWalkieTalkie == 3));

    notifyListeners();
  }

  /// Start recording audio
  ///TypeView 1: View Principal
  ///TypeView 2: View Walkies talkie
  ///Type 1: Record all user business
  ///Type 2: Record call center
  ///Type 3: Record all user driver
  void startOrStopRecording(
    BuildContext context,
    int typeEmit,
    int typeView,
  ) async {
    final prServiceSocketsRead = context.read<ProviderServiceSocket>();
    try {
      if (isRecording) {
        _recorderController!.reset();
        final path = await _recorderController!.stop(false);
        if (path != null) {
          _isRecordingCompleted = true;
        }
        if (_recorderController!.recordedDuration >
            const Duration(seconds: 1)) {
          if (path != null && File(path).lengthSync() != 0) {
            var byteAudio = await GlobalFunction().getByteAudio(path);
            prServiceSocketsRead.sendChatAudioWalkiesTalkie(
                byteAudio, typeEmit);
          }
        }
        if (isRecording) _recorderController!.refresh();
      } else {
        _pathAudio = await GlobalFunction().getPathAudio();
        if (_pathAudio == null || _pathAudio!.isEmpty) return;
        await _recorderController!.record(path: _pathAudio);
      }
    } catch (e) {
      debugPrint("ERROR >>> AUDIO ${e.toString()}");
    } finally {
      isRecording = !isRecording;
    }
  }

  /// Initial chat audio walkies talkie
  void initialChatAudio() {
    playerChat.onPlayerStateChanged.listen((audio.PlayerState state) {
      if (state == audio.PlayerState.playing) {
        _showChatAudio = true;
        notifyListeners();
      } else {
        _showChatAudio = false;
        notifyListeners();
      }
    }, onError: (msg) {
      if (kDebugMode) {
        print('ERROR CHAT AUDIO WALKIES TALKIE: $msg');
      }
    });
  }

  /// Save data list chat audio
  void addAudioWalkies(String name, String uid, String path, int typeAudio) {
    Chat chat = Chat();
    chat.stateChat = false;
    chat.message = name;
    chat.uid = uid;
    chat.url = '';
    chat.typeAudioWalkieTalkie = typeAudio;
    chat.pathAudio = path;
    chat.hour = GlobalFunction().hour.format(GlobalFunction().dateNow);
    chat.date = GlobalFunction().date.format(GlobalFunction().dateNow);
    chat.isPlaying = false;
    listChatAudio!.add(chat);
    notifyListeners();
    GlobalFunction().playAudio(GlobalLabel.directionAudio);
    addChatFilterAudio(typeAudio, chat);
    GlobalPreference().setWalkiesTalkie(listChatAudio!);
  }

  /// Delete audios walkies talkie after 24 hours
  void deleteAudioWalkiesTalkie() {
    if (listChatAudio!.isEmpty) return;
    List<Chat> elementsToRemove = [];
    for (Chat chat in listChatAudio!) {
      if (chat.pathAudio == null) return;
      DateTime dateChat = GlobalFunction().date.parse(chat.date!);
      Duration difference = GlobalFunction().dateNow.difference(dateChat);
      if (difference.inDays <= 1) {
        if (chat.pathAudio != null) {
          File(chat.pathAudio!).delete();
        }
        elementsToRemove.add(chat);
      }
    }
    listChatAudio!.removeWhere((element) => elementsToRemove.contains(element));
    GlobalPreference().setWalkiesTalkie(listChatAudio!);
    deleteListChatAudio();
    chatFilterAudio();
    notifyListeners();
  }

  /// Filter chat audio for selected of destiny
  /// TypeAudio 1: Business
  /// TypeAudio 2: Call center
  /// TypeAudio 3: All user driver
  void addChatFilterAudio(int typeAudio, Chat chat) {
    switch (typeAudio) {
      case 1:
        listFilterChatAudioBusiness.insert(0, chat);
        break;
      case 2:
        listFilterChatAudioCallCenter.insert(0, chat);
        break;
      case 3:
        listFilterChatAudioAllDriver.insert(0, chat);
        break;
    }
    notifyListeners();
  }

  /// Activate record user all business
  /// Get audio of other person
  /// TypeAudio 1: User all business
  /// TypeAudio 2: Call center
  /// TypeAudio 3: All
  void activateAudioWalkiesTalkie() {
    final prServiceSocketRead =
        GlobalFunction.context.currentContext!.read<ProviderServiceSocket>();

    prServiceSocketRead.activateListenRecordUserBusiness((data) {
      _dataEmitChat = ModelDataEmit.fromMap(data[0]);
      getAudioWalkiesTalkie(_dataEmitChat!.n!, data[1], 1);
      return null;
    });

    prServiceSocketRead.activateListenRecordCallCenter((data) {
      _dataEmitChat = ModelDataEmit.fromMap(data[0]);
      getAudioWalkiesTalkie(
        _dataEmitChat!.n!,
        data[1],
        2,
      );
      return null;
    });

    prServiceSocketRead.activateListenRecordAll((data) {
      _dataEmitChat = ModelDataEmit.fromMap(data[0]);
      getAudioWalkiesTalkie(
        _dataEmitChat!.n!,
        data[1],
        3,
      );
      return null;
    });
  }

  /// Get audio walkies talkie
  /// UID 124 = Get audio other user
  getAudioWalkiesTalkie(String name, dynamic data, int typeAudio) async {
    if (data != null) {
      var path = await GlobalFunction().getPathDirectoryAudio(data);
      if (path == null) return;
      playerChat.play(audio.DeviceFileSource(path));
      addAudioWalkies(name, "124", path, typeAudio);
    }
  }
}
