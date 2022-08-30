import 'dart:convert';

import 'package:logistika/helpers/app_key.dart';
import 'package:logistika/helpers/helpers.dart';
import 'package:logistika/helpers/system/snackbar.dart';
import 'package:logistika/routes/app_adapters.dart';
import 'package:logistika/services/exceptions/app_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';

class AuthController extends GetxController {
  final IAuthRepository repository;
  AuthController({required this.repository});

  var isLoading = false.obs;
  var isObscureText = true.obs;

  var loginEmailText = TextEditingController();
  var loginPasswordText = TextEditingController();

  var registNamaText = TextEditingController();
  var registHpText = TextEditingController();
  var registEmailText = TextEditingController();
  var registPasswordText = TextEditingController();
  var registAngkatanText = TextEditingController();
  var listYears = Helpers.genRangeYear();

  var forgotEmailText = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  void onLogin() async {
    isLoading(true);
    try {
      Map body = {
        "email": loginEmailText.text,
        "password": loginPasswordText.text
      };
      await repository.postLogin(body).then((res) {
        if (res.statusCode == 200) {
          final bearer = "Bearer ${res.data['token']}";
          final user = jsonEncode(res.data['data']);
          AuthPrefs.setToken(bearer);
          AuthPrefs.setUser(user);
          // var load = AuthPrefs.getToken();
          // print("token1 " + load!);
          // var loadUser = jsonDecode(AuthPrefs.getUser()!);
          // print("photo " + loadUser['photo']);
          Get.offAllNamed(Routes.DASHBOARD);
        } else if (res.statusCode == 400) {
          isLoading(false);
          AppSnackBar.info("${res.data['message']}");
        } else {
          isLoading(false);
          loginEmailText.clear();
          loginPasswordText.clear();
          AppSnackBar.error("${res.data['message']}");
        }
      });
    } catch (e) {
      isLoading(false);
      throw AppException(message: e.toString());
    }
  }

  void onRegister() async {
    isLoading(true);
    Map body = {
      "fullname": registNamaText.text,
      "phone": registHpText.text,
      "email": registEmailText.text,
      "password": registPasswordText.text,
      "angkatan": registAngkatanText.text
    };
    await repository.postRegister(body).then((res) {
      try {
        if (res.statusCode == 200) {
          if ((res.data as Map).containsKey('message')) {
            resetAll();
            Get.toNamed(Routes.LOGIN);
            AppSnackBar.success(
                "Keanggotaan Anda ditunda untuk diverifikasi terlebih dahulu. Periksa email untuk melihat status keanggotaan. Terimakasih.",
                seconds: 8);
          }
        } else if (res.statusCode == 400) {
          AppSnackBar.info("${res.data['message']['message']}");
        } else {
          AppSnackBar.error("${res.data['message']}");
        }
        isLoading(false);
      } catch (e) {
        isLoading(false);
        throw AppException(message: e.toString());
      }
    });
  }

  void forgotPassword() async {
    isLoading(true);
    Map body = {"email": forgotEmailText.text};
    await repository.postForget(body).then((res) {
      try {
        if (res.statusCode == 200) {
          isLoading(false);
          Get.toNamed(Routes.LOGIN);
          AppSnackBar.success(
              "password has been reset, please check email and login again");
        } else if (res.statusCode == 400) {
          isLoading(false);
          AppSnackBar.info("${res.data['message']}");
        } else {
          isLoading(false);
          forgotEmailText.clear();
          AppSnackBar.error("${res.data['message']}");
        }
      } catch (e) {
        isLoading(false);
        throw AppException(message: e.toString());
      }
    });
  }

  void obscureText() {
    isObscureText.value = !isObscureText.value;
  }

  void resetAll() {
    isLoading(false);
    loginEmailText.clear();
    loginPasswordText.clear();
    registNamaText.clear();
    registHpText.clear();
    registEmailText.clear();
    registPasswordText.clear();
    registAngkatanText.clear();
    forgotEmailText.clear();
    isObscureText(true);
  }
}
