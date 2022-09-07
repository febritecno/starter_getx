import 'package:absen/modules/auth/controllers/auth_controller.dart';
import 'package:absen/shared/widgets/templates/appbar_template.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends GetView<AuthController> {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppbarTemplate(title: "Register", children: []);
  }
}
