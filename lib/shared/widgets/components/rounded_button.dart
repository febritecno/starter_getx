import 'package:logistika/shared/widgets/text_app.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;
  final double? fontSize, borderCircular;
  final Color? color, fontColor;
  final FontWeight? fontWeight;

  final LinearGradient? linearGradient;

  const RoundedButton(this.title,
      {Key? key,
      this.onTap,
      this.fontSize,
      this.color,
      this.fontWeight,
      this.borderCircular,
      this.fontColor,
      this.linearGradient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
          ],
          gradient: linearGradient ?? null,
          color: color,
          borderRadius: BorderRadius.circular(borderCircular ?? 20)),
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          elevation: MaterialStateProperty.all<double>(0),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                borderCircular ?? 20,
              ),
            ),
          ),
        ),
        child: TextApp(title!,
            color: fontColor,
            fontSize: fontSize,
            fontWeight: fontWeight ?? FontWeight.normal),
      ),
    ));
  }
}
