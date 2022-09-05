import 'package:logistika/helpers/third_party/sizer/sizer.dart';
import 'package:logistika/modules/auth/controllers/auth_controller.dart';
import 'package:logistika/routes/app_pages.dart';
import 'package:logistika/routes/routes.dart';
import 'package:logistika/shared/constants.dart';
import 'package:logistika/shared/widgets/loading_app.dart';
import 'package:logistika/shared/widgets/text_app.dart';
import 'package:logistika/shared/theme.dart';
import 'package:logistika/shared/widgets/components/rounded_button.dart';
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
              children: [
                Column(
                  children: [
                    Container(
                        padding: EdgeInsets.only(top: 20.w, bottom: 14.w),
                        alignment: Alignment.topCenter,
                        child: Image.asset(IMAGE_PATH + 'logistika_login.png',
                            height: 20.w)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextApp('Welcome to Logistika',
                              color: Colors.white,
                              textAlign: TextAlign.start,
                              fontSize: 20.sp,
                              padding: EdgeInsets.only(bottom: 2.h),
                              fontWeight: FontWeight.w800),
                          TextApp('User Nama',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              padding: EdgeInsets.symmetric(vertical: 1.2.h),
                              fontSize: 12.sp),
                          TextFormField(
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
                                  vertical: 2.h, horizontal: 4.w),
                              hintStyle: TextStyle(color: Colors.white),
                              hintText: "Nama",
                              fillColor: kSemiBlueColor,
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 1.h),
                          TextApp('Password',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              padding: EdgeInsets.symmetric(vertical: 1.2.h),
                              fontSize: 12.sp),
                          TextFormField(
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
                                  vertical: 2.h, horizontal: 4.w),
                              hintText: "Password",
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
                          SizedBox(height: 2.h),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: Column(children: [
                              RoundedButton(
                                'LOG IN',
                                fontSize: 16.sp,
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
                                onTap: () => Get.toNamed(Routes.DASHBOARD),
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
                            fontSize: 14.sp,
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
                  padding: EdgeInsets.symmetric(vertical: 8.w),
                  fontSize: 16.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
