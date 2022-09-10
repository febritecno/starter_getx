import 'package:absen/modules/auth/controllers/auth_controller.dart';
import 'package:absen/shared/widgets/loading_app.dart';
import 'package:absen/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingApp(
        isLoading: controller.isLoading.value,
        backroundColor: Colors.black,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: kDarkBlueColor,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}
