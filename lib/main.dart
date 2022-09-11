import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:absen/routes/routes.dart';
import 'package:absen/services/app_services.dart';
import 'package:absen/shared/constants.dart';
import 'package:sizer/sizer.dart';

import 'routes/app_pages.dart';

void main() async {
  initServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        enableLog: true,
      );
    });
  }
}
