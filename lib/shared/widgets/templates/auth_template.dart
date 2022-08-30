import 'package:logistika/helpers/third_party/sizer/sizer.dart';
import 'package:logistika/shared/constants.dart';
import 'package:logistika/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AuthTemplate extends StatelessWidget {
  final Widget? child;
  final bool isAppbar;
  final VoidCallback? onTap;

  const AuthTemplate({Key? key, this.child, this.isAppbar: false, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: isAppbar
              ? AppBar(
                  systemOverlayStyle:
                      SystemUiOverlayStyle(statusBarColor: kBlueColor),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: onTap ?? () => Get.back(),
                  ),
                )
              : PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  child: SizedBox(),
                ),
          backgroundColor: kBlueColor,
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: isAppbar ? 1.4.w : 14.w),
                    alignment: Alignment.topCenter,
                    child: Image.asset(ICON_PATH + 'splash_logo.png',
                        height: 8.w, color: Colors.white),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(26),
                    topLeft: Radius.circular(26),
                  ),
                ),
                margin: EdgeInsets.only(top: isAppbar ? 12.h : 20.h),
                child: Container(
                  child: SingleChildScrollView(
                    child: child,
                    scrollDirection: Axis.vertical,
                  ),
                  margin: EdgeInsets.only(
                      top: 4.h, left: 4.w, right: 4.w, bottom: 2.h),
                ),
                height: Get.height,
                width: Get.width,
              )
            ],
          )),
    );
  }
}
