import 'package:logistika/helpers/third_party/sizer/sizer.dart';
import 'package:logistika/shared/theme.dart';
import 'package:logistika/shared/widgets/text_app.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton(this.title,
      {Key? key,
      required this.onTap,
      this.circularRadius,
      this.color,
      this.height,
      this.fontSize,
      this.backroundColor})
      : super(key: key);

  final String? title;
  final VoidCallback onTap;
  final Color? color, backroundColor;
  final double? height, circularRadius, fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backroundColor ?? Colors.white,
      width: double.infinity,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(circularRadius ?? 12))),
                shadowColor: MaterialStateProperty.all(Colors.transparent),
                backgroundColor: MaterialStateProperty.all(color ?? kBlueColor),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: height ?? 4.w))),
            onPressed: onTap,
            child: TextApp(
              "$title",
              fontSize: fontSize ?? 16.sp,
              color: Colors.white,
              fontWeight: bold,
            ),
          )),
    );
  }
}
