import 'package:flutter/foundation.dart';
import 'package:myapp/helpers/third_party/sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myapp/routes/routes.dart';
import 'package:myapp/services/app_services.dart';
import 'package:myapp/shared/constants.dart';

import 'routes/app_pages.dart';

void main() async {
  await initServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        initialRoute: Routes.INITIAL,
        getPages: AppPages.list,
        defaultTransition: Transition.noTransition,
        title: APP_NAME,
        debugShowCheckedModeBanner: false,
        enableLog: kDebugMode,
      );
    });
  }
}
