import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/response/response_message_referred.dart';
import '../../domain/entities/model_message_referred.dart';

class ProviderReferred with ChangeNotifier {
  List<ModelMessageReferred>? listMessageReferred = [];

  void addMessageReferred(ResponseMessageReferred responseMessageReferred) {
    if (listMessageReferred!.isNotEmpty) listMessageReferred!.clear();
    listMessageReferred!.addAll(responseMessageReferred.data!);
  }

  void sharedCode(String code) {
    Share.share(
        '¡Hola! 👋 Te comparto mi código para que te unas a Clipp📱. Al registrarte, usa mi código: *$code* y disfruta de la libertad de movilizarse🚖 seguro, siempre. https://app.clipp.app/clipp');
  }
}
