import 'package:logistika/helpers/system/bottomsheet.dart';
import 'package:logistika/helpers/third_party/sizer/sizer.dart';
import 'package:logistika/modules/auth/controllers/auth_controller.dart';
import 'package:logistika/shared/theme.dart';
import 'package:logistika/shared/widgets/components/ripple_button.dart';
import 'package:logistika/shared/widgets/loading_app.dart';
import 'package:logistika/shared/widgets/templates/auth_template.dart';
import 'package:logistika/shared/widgets/text_app.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../routes/routes.dart';

class RegisterPage extends GetView<AuthController> {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingApp(
        isLoading: controller.isLoading.value,
        backroundColor: Colors.black,
        child: AuthTemplate(
          onTap: () {
            controller.resetAll();
            Get.toNamed(Routes.LOGIN);
          },
          isAppbar: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 8.h,
                child: Column(
                  children: [
                    TextApp('Sign Up',
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold),
                    TextApp(
                      'Enter your credentials to Continue',
                      fontSize: 14.sp,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nama'),
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controller.registNamaText,
                validator: MultiValidator(
                    [RequiredValidator(errorText: 'this field is required')]),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'No. HP'),
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controller.registHpText,
                validator: MultiValidator(
                    [RequiredValidator(errorText: 'this field is required')]),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controller.registEmailText,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'this field is required'),
                  EmailValidator(errorText: 'enter a valid email address'),
                ]),
              ),
              TextFormField(
                obscureText: controller.isObscureText.value,
                controller: controller.registPasswordText,
                decoration: InputDecoration(
                  labelText: 'Password',
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
              TextFormField(
                controller: controller.registAngkatanText,
                readOnly: true,
                onTap: () => AppBottomSheet.list(
                  title: "Pilih Angkatan",
                  isFull: true,
                  items: (i) => ListBottomSheet(
                      title: "${controller.listYears[i]}",
                      onTap: () {
                        controller.registAngkatanText.text =
                            "${controller.listYears[i]}";
                      }),
                  itemLenght: controller.listYears.length,
                ),
                decoration: InputDecoration(
                  labelText: 'Pilih Angkatan',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () => controller.obscureText(),
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator:
                    RequiredValidator(errorText: 'this field is required'),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Column(children: [
                  SizedBox(
                    height: 6.h,
                    child: RippleButton(
                      'SIGN UP',
                      fontSize: 14.sp,
                      borderCircular: 12,
                      onTap: () => controller.onRegister(),
                    ),
                  ),
                ]),
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextApp(
                    'Already have an account? ',
                    color: Colors.black,
                    fontSize: 12.sp,
                  ),
                  GestureDetector(
                      onTap: () {
                        controller.resetAll();
                        Get.toNamed(Routes.LOGIN);
                      },
                      child: TextApp(
                        'Login Here',
                        color: kBlueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
