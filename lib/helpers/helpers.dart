import 'package:myapp/helpers/app_key.dart';
import 'package:myapp/modules/auth/views/login_page.dart';
import 'package:myapp/routes/app_bindings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/routes.dart';

class Helpers {
  static percentWidth(BuildContext context, double width) {
    return ((MediaQuery.of(context).size.width) * width) / 100;
  }

  static percentHeight(BuildContext context, double height) {
    return ((MediaQuery.of(context).size.height) * height) / 100;
  }

  static height(BuildContext context) {
    return (MediaQuery.of(context).size.height);
  }

  static width(BuildContext context) {
    return (MediaQuery.of(context).size.width);
  }

  static clearToken() async {
    await AuthPrefs.removeKey('user_key');
    await AuthPrefs.clearAll();
    Get.offAllNamed(Routes.LOGIN);
    Get.to(LoginPage(), binding: AuthBinding());
  }

  static back({seconds = 0, callback}) async {
    Future.delayed(
        Duration(seconds: seconds),
        (callback != null)
            ? callback
            : () {
                return Navigator.pop(Get.context!);
              });
  }
}
