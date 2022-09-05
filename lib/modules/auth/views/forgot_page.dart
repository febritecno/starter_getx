// import 'package:logistika/helpers/third_party/sizer/sizer.dart';
// import 'package:logistika/modules/auth/controllers/auth_controller.dart';
// import 'package:logistika/shared/theme.dart';
// import 'package:logistika/shared/widgets/components/ripple_button.dart';
// import 'package:logistika/shared/widgets/loading_app.dart';
// import 'package:logistika/shared/widgets/templates/auth_template.dart';
// import 'package:logistika/shared/widgets/text_app.dart';
// import 'package:flutter/material.dart';
// import 'package:form_field_validator/form_field_validator.dart';
// import 'package:get/get.dart';

// import '../../../routes/routes.dart';

// class ForgotPage extends GetView<AuthController> {
//   const ForgotPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Obx((() => LoadingApp(
//           isLoading: controller.isLoading.value,
//           backroundColor: Colors.black,
//           child: AuthTemplate(
//             isAppbar: true,
//             onTap: () {
//               controller.resetAll();
//               Get.toNamed(Routes.LOGIN);
//             },
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 8.h,
//                   child: Column(
//                     children: [
//                       TextApp('Forgot Password',
//                           color: Colors.black,
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.bold),
//                       TextApp(
//                         'Enter your email address',
//                         fontSize: 14.sp,
//                       ),
//                     ],
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                   ),
//                 ),
//                 TextFormField(
//                   controller: controller.forgotEmailText,
//                   decoration: InputDecoration(labelText: 'Email'),
//                   keyboardType: TextInputType.emailAddress,
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   validator: MultiValidator([
//                     RequiredValidator(errorText: 'this field is required'),
//                     EmailValidator(errorText: 'enter a valid email address'),
//                   ]),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: 4.h),
//                   child: Column(children: [
//                     SizedBox(
//                       height: 6.h,
//                       child: RippleButton(
//                         'SEND',
//                         borderCircular: 12,
//                         fontSize: 14.sp,
//                         onTap: () => controller.forgotPassword(),
//                       ),
//                     ),
//                   ]),
//                 ),
//                 SizedBox(height: 2.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     TextApp(
//                       'Already have an account? ',
//                       color: Colors.black,
//                       fontSize: 12.sp,
//                     ),
//                     GestureDetector(
//                         onTap: () {
//                           controller.resetAll();
//                           Get.toNamed(Routes.LOGIN);
//                         },
//                         child: TextApp(
//                           'Login Here',
//                           color: kBlueColor,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 12.sp,
//                         )),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         )));
//   }
// }
