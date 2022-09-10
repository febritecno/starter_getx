import 'package:absen/helpers/utils/prefs_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

/// The only way to actually delete a GetxService,
/// is with Get.reset() which is like a "Hot Reboot" of your app.
/// So remember, if you need absolute persistence of a class instance during the lifetime of your app, use GetxService.
void initServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => PrefsService().init());
}

//* Write Services SharedPreferences
class PrefsService extends GetxService {
  Future<PrefsService> init() async {
    await Prefs.init();
    return this;
  }
}
