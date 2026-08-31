import 'package:myapp/modules/auth/controllers/auth_controller.dart';
import 'package:myapp/helpers/third_party/sizer/sizer.dart';
import 'package:myapp/routes/app_pages.dart';
import 'package:myapp/shared/constants.dart';
import 'package:myapp/shared/widgets/loading_app.dart';
import 'package:myapp/shared/widgets/text_app.dart';
import 'package:myapp/shared/theme.dart';
import 'package:myapp/shared/widgets/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

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
              children: [
                Column(
                  children: [
                    Container(
                        padding: EdgeInsets.only(top: 20.wp, bottom: 14.wp),
                        alignment: Alignment.topCenter,
                        child: Image.asset('${IMAGE_PATH}app_logo.png',
                            height: 24.wp)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.wp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextApp('Welcome to MyApp',
                              color: Colors.white,
                              textAlign: TextAlign.start,
                              fontSize: 20.spp,
                              padding: EdgeInsets.only(bottom: 2.hp),
                              fontWeight: FontWeight.w800),
                          TextApp('Username',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              padding: EdgeInsets.symmetric(vertical: 1.2.hp),
                              fontSize: 12.spp),
                          TextFormField(
                            controller: controller.loginUsernameText,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(12)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2.hp, horizontal: 4.wp),
                              hintStyle: TextStyle(color: Colors.white),
                              hintText: "username (try: emilys)",
                              fillColor: kSemiBlueColor,
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 1.hp),
                          TextApp('Password',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              padding: EdgeInsets.symmetric(vertical: 1.2.hp),
                              fontSize: 12.spp),
                          TextFormField(
                            controller: controller.loginPasswordText,
                            obscureText: controller.isObscureText.value,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: kDarkGreyColor, width: 1),
                                  borderRadius: BorderRadius.circular(14)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: kDarkGreyColor, width: 1),
                                  borderRadius: BorderRadius.circular(14)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(14)),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.white),
                              suffixIconColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2.hp, horizontal: 4.wp),
                              hintText: "password (try: emilyspass)",
                              fillColor: kSemiBlueColor,
                              suffixIcon: IconButton(
                                color: Colors.white,
                                icon: Icon(controller.isObscureText.value
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () => controller.obscureText(),
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 2.hp),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.hp),
                            child: Column(children: [
                              RoundedButton(
                                'LOG IN',
                                fontSize: 16.spp,
                                fontWeight: extraBold,
                                linearGradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.3, 1.0],
                                  colors: [Colors.white, Colors.grey],
                                ),
                                borderCircular: 18,
                                fontColor: kBlueColor,
                                color: Colors.white,
                                onTap: () => controller.onLogin(),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.resetAll();
                            Get.toNamed(AppPages.FORGOT_PASSWORD);
                          },
                          child: TextApp(
                            'Forget Password ? ',
                            color: Colors.white,
                            fontSize: 14.spp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                TextApp(
                  'First time user? SIGN UP',
                  color: Colors.white,
                  textAlign: TextAlign.center,
                  fontWeight: bold,
                  padding: EdgeInsets.symmetric(vertical: 8.wp),
                  fontSize: 16.spp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
