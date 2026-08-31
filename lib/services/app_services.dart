import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:myapp/helpers/utils/prefs_utils.dart';
import 'package:myapp/services/api_client/api_client.dart';

/// Registers app-wide singletons before the UI starts. Await this in main()
/// so prefs (and the token they hold) are ready before the first request.
Future<void> initServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();
  await Get.putAsync(() => PrefsService().init());
  Get.put(ApiClient(Dio()), permanent: true);
}

//* SharedPreferences service, kept alive for the whole app lifetime.
class PrefsService extends GetxService {
  Future<PrefsService> init() async {
    await Prefs.init();
    return this;
  }
}
