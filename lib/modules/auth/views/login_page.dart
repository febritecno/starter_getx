import 'package:logistika/helpers/third_party/sizer/sizer.dart';
import 'package:logistika/modules/auth/controllers/auth_controller.dart';
import 'package:logistika/routes/app_pages.dart';
import 'package:logistika/shared/widgets/loading_app.dart';
import 'package:logistika/shared/widgets/text_app.dart';
import 'package:logistika/shared/theme.dart';
import 'package:logistika/shared/widgets/components/ripple_button.dart';
import 'package:logistika/shared/widgets/templates/auth_template.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => LoadingApp(
          isLoading: controller.isLoading.value,
          backroundColor: Colors.black,
          child: AuthTemplate(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
                child: Column(
                  children: [
                    TextApp('Welcome Back',
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800),
                    TextApp(
                      'Login with your account',
                      fontSize: 14.sp,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email address',
                    contentPadding: EdgeInsets.symmetric(vertical: 2.h),
                    floatingLabelBehavior: FloatingLabelBehavior.always),
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controller.loginEmailText,
                validator: MultiValidator([
                  EmailValidator(errorText: 'enter a valid email address'),
                  RequiredValidator(errorText: 'this field is required')
                ]),
              ),
              SizedBox(height: 1.h),
              TextFormField(
                obscureText: controller.isObscureText.value,
                controller: controller.loginPasswordText,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.symmetric(vertical: 2.h),
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  suffixIcon: IconButton(
                    icon: Icon(controller.isObscureText.value
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () => controller.obscureText(),
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator:
                    RequiredValidator(errorText: 'this field is required'),
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Column(children: [
                  SizedBox(
                    height: 6.h,
                    child: RippleButton(
                      'LOGIN',
                      fontSize: 14.sp,
                      borderCircular: 12,
                      onTap: () => controller.onLogin(),
                    ),
                  ),
                  SizedBox(height: 1.4.h),
                  SizedBox(
                    height: 6.h,
                    child: RippleButton(
                      'SIGN UP',
                      fontSize: 14.sp,
                      borderCircular: 12,
                      onTap: () {
                        controller.resetAll();
                        Get.toNamed(AppPages.SIGN_UP);
                      },
                      color: Colors.green,
                    ),
                  ),
                ]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextApp(
                    'Forgot your password? ',
                    color: Colors.black,
                    fontSize: 12.sp,
                  ),
                  GestureDetector(
                      onTap: () {
                        controller.resetAll();
                        Get.toNamed(AppPages.FORGOT_PASSWORD);
                      },
                      child: TextApp(
                        'Reset here',
                        color: kBlueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      )),
                ],
              ),
            ],
          )),
        ));
  }
}
