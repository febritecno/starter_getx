import 'package:logistika/helpers/third_party/sizer/sizer.dart';
import 'package:logistika/shared/constants.dart';
import 'package:logistika/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainHeader extends StatelessWidget {
  final TabBar? tabBar;
  final bool? isVisible;
  const MainHeader({Key? key, required this.tabBar, required this.isVisible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: kBlueColor),
        elevation: 0,
        leadingWidth: 0,
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        bottom: tabBar,
      ),
      Visibility(
        visible: isVisible ?? true,
        child: Container(
          height: 6.h,
          color: kBlueColor,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  IMAGE_PATH + 'mini_logo.png',
                  scale: 3,
                ),
                Container(
                  width: 34.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        IMAGE_PATH + 'logo_side.png',
                        scale: 4.2,
                      ),
                      Image.asset(
                        IMAGE_PATH + 'logo_notif.png',
                        scale: 2,
                      ),
                      Image.asset(
                        IMAGE_PATH + 'logo_search.png',
                        scale: 2,
                      ),
                      Image.asset(
                        IMAGE_PATH + 'logo_chat.png',
                        scale: 2,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )
    ]);
  }
}
