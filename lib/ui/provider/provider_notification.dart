import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:story_view/story_view.dart';

import '../../data/response/response_notification_business.dart';
import '../../domain/entities/model_notification_business.dart';
import '../util/global_function.dart';
import '../util/global_label.dart';
import 'provider_principal.dart';
import 'provider_service/provider_service_rest.dart';

class ProviderNotification with ChangeNotifier {
  TextEditingController editReply = TextEditingController();
  List<ModelNotificationBusiness>? listNotification = [];
  bool? _contList = false;
  int? idQuestion = 0;
  ModelNotificationBusiness? _notificationBusiness =
      ModelNotificationBusiness();
  List<StoryItem>? _storyItems = [];
  StoryController? _storyController = StoryController();
  int? _index = 0;

  StoryController get storyController => _storyController!;

  set storyController(StoryController value) {
    _storyController = value;
  }

  int get index => _index!;

  set index(int value) {
    _index = value;
  }

  List<StoryItem> get storyItems => _storyItems!;

  set storyItems(List<StoryItem> value) {
    _storyItems = value;
  }

  ModelNotificationBusiness? get notificationBusiness => _notificationBusiness;

  set notificationBusiness(ModelNotificationBusiness? value) {
    if (value != null) {
      _notificationBusiness = value;
    }
  }

  bool get contList => _contList!;

  set contList(bool value) {
    _contList = value;
  }

  /// Add new notification to the list
  void addListNotification(ResponseNotificationBusiness notificationBusiness) {
    final prPrincipalRead = GlobalFunction.context.currentContext!.read<ProviderPrincipal>();
    if (listNotification!.isNotEmpty) listNotification!.clear();
    if (notificationBusiness.lN!.isEmpty) return;
    prPrincipalRead.countNotification = 0;
    index = 0;
    listNotification!.addAll(notificationBusiness.lN!);
    for (ModelNotificationBusiness modelNotificationBusiness
        in listNotification!) {
      if (modelNotificationBusiness.read == 0 &&
          modelNotificationBusiness.type == 1) {
        prPrincipalRead.countNotification++;
      }
    }
    if (listNotification!.isNotEmpty) {
      _contList = false;
    } else {
      _contList = true;
    }
    notifyListeners();
  }

  /// Detail notification
  Future detailNotification(int position) async {
    _notificationBusiness = listNotification![position];
    notifyListeners();
  }

  /// Update check question
  void updateCheckQuestion(int idQuestion) {
    for (Question question in _notificationBusiness!.lP!) {
      if (question.idQuestion == idQuestion) {
        question.check = true;
      } else {
        question.check = false;
      }
      notifyListeners();
    }
  }

  /// Get id question
  getIdQuestion() {
    for (Question question in _notificationBusiness!.lP!) {
      if (question.check!) {
        idQuestion = question.idQuestion!;
        break;
      }
    }
    return idQuestion;
  }

  /// send reply notification
  void sendReplyNotification(BuildContext context) {
    final prServiceRestRead = context.read<ProviderServiceRest>();
    if (getIdQuestion() == 0) {
      return GlobalFunction()
          .messageAlert(context, GlobalLabel.textSelectedQuestion);
    }

    if (_notificationBusiness!.type! == 4 && editReply.text.trim().isEmpty) {
      return GlobalFunction().messageAlert(context, GlobalLabel.textWriteReply);
    }
    prServiceRestRead.sendAnswerNotification(context, idQuestion!);
  }

  void addStoryItems(BuildContext context) {
    if (listNotification!.isNotEmpty) {
      storyItems.clear();
      for (ModelNotificationBusiness modelNotificationBusiness in listNotification!) {
        if (modelNotificationBusiness.type == 1 && modelNotificationBusiness.read == 0) {
          storyItems.add(
            StoryItem.pageImage(
              key: UniqueKey(),
              shown: false,
              url: modelNotificationBusiness.imageBulletin!,
              controller: storyController,
              caption: "${modelNotificationBusiness.bulletin}\n${modelNotificationBusiness.business}",
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    }
  }


  void viewStory(BuildContext context) {
    final prServiceRestRead = context.read<ProviderServiceRest>();
    for (ModelNotificationBusiness modelNotificationBusiness in listNotification!) {
      if (modelNotificationBusiness.read == 0) {
        prServiceRestRead.sendWatchNotification(
            context, modelNotificationBusiness.idBulletin!);
      }

    }
  }
}
