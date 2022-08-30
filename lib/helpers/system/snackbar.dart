import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackBar {
  static void dynamic(
      {String title = "Info",
      required String message,
      Color colorText = Colors.white,
      Color backgroundColor = Colors.black,
      required Icon icon,
      SnackPosition snackPosition = SnackPosition.BOTTOM,
      int seconds = 3}) {
    Get.snackbar(
      title,
      message,
      icon: icon,
      colorText: colorText,
      backgroundColor: backgroundColor,
      forwardAnimationCurve: Curves.fastOutSlowIn,
      snackPosition: snackPosition,
      shouldIconPulse: true,
      margin: EdgeInsets.only(bottom: 5, left: 20, right: 20),
      isDismissible: true,
      duration: Duration(seconds: seconds),
    );
  }

  static void success(String message, {seconds}) {
    Get.snackbar(
      "Success",
      message,
      icon: Icon(Icons.check_circle_outline_rounded, color: Colors.white),
      colorText: Colors.white,
      backgroundColor: Colors.green[900],
      forwardAnimationCurve: Curves.fastOutSlowIn,
      snackPosition: SnackPosition.TOP,
      shouldIconPulse: true,
      margin: EdgeInsets.only(bottom: 5, left: 20, right: 20),
      isDismissible: true,
      duration: Duration(seconds: seconds ?? 3),
    );
  }

  static void info(String message) {
    Get.snackbar(
      "Info",
      message,
      colorText: Colors.white,
      backgroundColor: Colors.black,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      reverseAnimationCurve: Curves.linear,
      snackPosition: SnackPosition.BOTTOM,
      shouldIconPulse: true,
      isDismissible: true,
      duration: Duration(seconds: 3),
    );
  }

  static void error(String message, {String? title}) {
    Get.snackbar(
      title ?? "Error",
      message,
      icon: Icon(Icons.error, color: Colors.white),
      colorText: Colors.white,
      backgroundColor: Colors.red[900],
      forwardAnimationCurve: Curves.fastOutSlowIn,
      snackPosition: SnackPosition.TOP,
      shouldIconPulse: true,
      margin: EdgeInsets.only(bottom: 5, left: 20, right: 20),
      isDismissible: true,
      duration: Duration(seconds: 3),
    );
  }
}
