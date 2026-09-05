import 'package:myapp/modules/auth/controllers/auth_controller.dart';
import 'package:myapp/helpers/third_party/sizer/sizer.dart';
import 'package:myapp/routes/app_pages.dart';
import 'package:myapp/shared/constants.dart';
import 'package:myapp/shared/widgets/loading_app.dart';
import 'package:myapp/shared/widgets/templates/appbar_template.dart';
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
        // AppbarTemplate is the app's single screen foundation. A custom-header
        // screen like login just hides the app bar (showAppBar: false).
        child: AppbarTemplate(
          showAppBar: false,
          backgroundColor: kDarkBlueColor,
          isCustom: true,
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
                        Padding(
                          padding: EdgeInsets.only(bottom: 2.hp),
                          child: Text('Welcome to MyApp',
                              textAlign: TextAlign.start,
                              style: kH2.copyWith(
                                  color: Colors.white,
                                  fontSize: 20.spp,
                                  fontWeight: FontWeight.w800)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.2.hp),
                          child: Text('Username',
                              style: kBody.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.spp)),
                        ),
                        TextFormField(
                          controller: controller.loginUsernameText,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.white),
                            hintText: "username (try: emilys)",
                            fillColor: kSemiBlueColor,
                          ),
                        ),
                        SizedBox(height: 1.hp),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.2.hp),
                          child: Text('Password',
                              style: kBody.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.spp)),
                        ),
                        TextFormField(
                          controller: controller.loginPasswordText,
                          obscureText: controller.isObscureText.value,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.white),
                            suffixIconColor: Colors.white,
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
                        ),
                        SizedBox(height: 2.hp),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.hp),
                          child: Column(children: [
                            RoundedButton(
                              'LOG IN',
                              fontSize: 16.spp,
                              fontWeight: extraBold,
                              linearGradient: const LinearGradient(
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
                        child: Text('Forget Password ? ',
                            style: kBody.copyWith(
                                color: Colors.white, fontSize: 14.spp)),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.wp),
                child: Text('First time user? SIGN UP',
                    textAlign: TextAlign.center,
                    style: kBody.copyWith(
                        color: Colors.white,
                        fontWeight: bold,
                        fontSize: 16.spp)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
