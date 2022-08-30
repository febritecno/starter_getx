import 'dart:async';
import 'dart:convert';

import 'package:logistika/helpers/app_key.dart';
import 'package:logistika/modules/auth/views/login_page.dart';
import 'package:logistika/routes/app_bindings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../routes/routes.dart';

class L {
  static og(data, {x = ''}) {
    return print("$data => L.og$x");
  }
}

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
    // back support ios & android. (jika pakai Get.back() untuk close popup tidak bekerja)
    Future.delayed(
        Duration(seconds: seconds),
        (callback != null)
            ? callback
            : () {
                return Navigator.pop(Get.context!);
              });
  }

  ///

  static dynamic getMemberId() {
    final userData = jsonDecode(AuthPrefs.getUser()!);
    final userId = userData['id'];
    return userId;
  }

  static List genRangeYear() {
    final initYear = 1960;
    final currentYear = int.parse(DateFormat('yyyy').format(DateTime.now()));
    List listYears = List.generate(
        (currentYear - initYear) + 20, (index) => initYear + index);
    return listYears;
  }

  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    final result = (to.difference(from).inHours / 24).round().abs();
    return result > 0 ? result : 0;
  }
}
