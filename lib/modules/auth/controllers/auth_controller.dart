import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isObscureText = true.obs;

  var loginEmailText = TextEditingController();
  var loginPasswordText = TextEditingController();

  var registNamaText = TextEditingController();
  var registHpText = TextEditingController();
  var registEmailText = TextEditingController();
  var registPasswordText = TextEditingController();
  var registAngkatanText = TextEditingController();

  var forgotEmailText = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }
}
