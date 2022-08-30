import 'package:logistika/shared/widgets/text_app.dart';
import 'package:flutter/material.dart';

class RippleButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final double? borderCircular;

  const RippleButton(this.title,
      {Key? key,
      this.onTap,
      this.fontSize,
      this.color,
      this.fontWeight,
      this.borderCircular})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          elevation: MaterialStateProperty.all<double>(0),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderCircular ?? 6))),
          overlayColor: MaterialStateProperty.resolveWith(
            (states) {
              return states.contains(MaterialState.pressed)
                  ? Colors.white.withOpacity(0.4)
                  : null;
            },
          ),
        ),
        child: TextApp(title!,
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: fontWeight ?? FontWeight.normal),
      ),
    );
  }
}
