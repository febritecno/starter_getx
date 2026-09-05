import 'package:myapp/shared/theme.dart';
import 'package:myapp/helpers/third_party/sizer/sizer.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton(this.title,
      {super.key,
      required this.onTap,
      this.circularRadius,
      this.color,
      this.height,
      this.fontSize,
      this.backroundColor});

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
          padding: EdgeInsets.symmetric(horizontal: 6.wp, vertical: 2.hp),
          child: ElevatedButton(
            style: ButtonStyle(
                shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(circularRadius ?? 12))),
                shadowColor: WidgetStateProperty.all(Colors.transparent),
                backgroundColor: WidgetStateProperty.all(color ?? kBlueColor),
                padding: WidgetStateProperty.all(
                    EdgeInsets.symmetric(vertical: height ?? 4.wp))),
            onPressed: onTap,
            child: Text(
              "$title",
              style: kButton.copyWith(
                  fontSize: fontSize ?? 16.spp,
                  color: Colors.white,
                  fontWeight: bold),
            ),
          )),
    );
  }
}
