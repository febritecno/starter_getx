import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:myapp/helpers/app_key.dart';
import 'package:myapp/helpers/system/snackbar.dart';
import 'package:myapp/modules/auth/models/auth_model.dart';
import 'package:myapp/repository/auth_repository.dart';
import 'package:myapp/routes/routes.dart';

class AuthController extends GetxController {
  final AuthRepository repository;
  AuthController({required this.repository});

  final isLoading = false.obs;
  final isObscureText = true.obs;

  final loginUsernameText = TextEditingController();
  final loginPasswordText = TextEditingController();

  Future<void> onLogin() async {
    isLoading(true);
    try {
      final res = await repository.postLogin({
        "username": loginUsernameText.text.trim(),
        "password": loginPasswordText.text,
      });
      if (res?.statusCode == 200) {
        final auth = AuthModel.fromJson(res!.data);
        AuthPrefs.setToken("Bearer ${auth.token}");
        AuthPrefs.setUser(jsonEncode(auth.user?.toJson()));
        Get.offAllNamed(Routes.DASHBOARD);
        return;
      }
      // dummyjson returns 400 { "message": "Invalid credentials" }
      AppSnackBar.error("${res?.data?['message'] ?? 'Login failed'}");
    } finally {
      isLoading(false);
    }
  }

  void obscureText() => isObscureText.value = !isObscureText.value;

  void resetAll() {
    loginUsernameText.clear();
    loginPasswordText.clear();
    isObscureText(true);
  }
}
