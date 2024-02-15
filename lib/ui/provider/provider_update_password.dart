import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../page/page_login.dart';
import '../util/global_function.dart';
import '../util/global_preference.dart';
import 'provider_login.dart';
import 'provider_map.dart';
import 'provider_service/provider_service_socket.dart';
import 'provider_splash.dart';

class ProviderUpdatePassword with ChangeNotifier {
  TextEditingController editFormerPassword = TextEditingController();
  TextEditingController editNewPassword = TextEditingController();

  /// Log out session
  void logOutSession() {
    final prLoginRead =
        GlobalFunction.context.currentContext!.read<ProviderLogin>();
    final prMapRead =
        GlobalFunction.context.currentContext!.read<ProviderMap>();
    final prServiceSocketRead =
        GlobalFunction.context.currentContext!.read<ProviderServiceSocket>();
    final prSplashRead= GlobalFunction.context.currentContext!.read<ProviderSplash>();
    prMapRead.resetTimerTracking();
    prMapRead.stopBackgroundLocation();

    GlobalPreference.getDataUser().then((dataUser) {
      if (dataUser == null || dataUser.user == null) {
        prLoginRead.stateBiometric = false;
      } else {
        prLoginRead.stateBiometric = true;
      }
    });
    prSplashRead.statusPage = true;
    prLoginRead.cleanTextField();
    GlobalPreference().setStateLogin(false);
    GlobalPreference().setStateService(false);
    prServiceSocketRead.disableGlobalEvents();
    prServiceSocketRead.socket.close();
    // GlobalPreference().setStateCenterTracing(false);
    // GlobalPreference.deleteWalkiesTalkie();
    // providerWalKieTalkie.deleteListChatAudio();
    GlobalFunction().nextPageUntilView(const PageLogin());
  }
}
