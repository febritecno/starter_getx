import 'package:absen/shared/theme.dart';
import 'package:absen/shared/widgets/text_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AppDialog {
  static void load(Widget child,
      {barrierDismissible = false, barrierColor = Colors.black45}) {
    Get.dialog(
      child,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<dynamic> showAlert(
      {required title,
      required btnLeft,
      required btnRight,
      required desc,
      onBtnLeft,
      onBtnRight}) {
    return showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertItem(
              btnLeft: btnLeft,
              btnRight: btnRight,
              desc: desc,
              onBtnLeft: onBtnLeft,
              onBtnRight: onBtnRight,
              title: title);
        });
  }
}

class AlertItem extends StatelessWidget {
  final String? title, desc, btnLeft, btnRight;
  final Widget? body, footer;
  final VoidCallback? onBtnLeft, onBtnRight;

  const AlertItem({
    Key? key,
    this.title,
    this.desc,
    this.btnLeft,
    this.btnRight,
    this.onBtnLeft,
    this.onBtnRight,
    this.body,
    this.footer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 80.h,
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color(0xFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              body == null
                  ? Column(
                      children: [
                        TextApp(
                          title!,
                          color: kBlueColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 16.sp,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                        ),
                        SizedBox(height: 2.h),
                        TextApp(
                          desc!,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          textAlign: TextAlign.center,
                          maxLines: 18,
                          softWrap: true,
                          overflow: TextOverflow.clip,
                        ),
                      ],
                    )
                  : body!,
              footer == null
                  ? Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    return kBlueColor;
                                  },
                                ),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 0)),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minimumSize:
                                    MaterialStateProperty.all(Size(30.w, 20)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                )),
                              ),
                              onPressed:
                                  onBtnLeft ?? () => Navigator.pop(context),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 1.w, vertical: 1.5.h),
                                child: TextApp(
                                  btnLeft!,
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              )),
                          SizedBox(width: 3.w),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  return kBlueColor;
                                },
                              ),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 0)),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize:
                                  MaterialStateProperty.all(Size(30.w, 20)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              )),
                            ),
                            onPressed: onBtnRight,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 1.w, vertical: 1.5.h),
                              child: TextApp(
                                btnRight!,
                                fontSize: 12.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : footer!
            ],
          ),
        ),
      ),
    );
  }
}
//*
