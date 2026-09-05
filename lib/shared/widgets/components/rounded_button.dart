import 'package:myapp/shared/theme.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;
  final double? fontSize, borderCircular;
  final Color? color, fontColor;
  final FontWeight? fontWeight;

  final LinearGradient? linearGradient;

  const RoundedButton(this.title,
      {super.key,
      this.onTap,
      this.fontSize,
      this.color,
      this.fontWeight,
      this.borderCircular,
      this.fontColor,
      this.linearGradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
          ],
          gradient: linearGradient,
          color: color,
          borderRadius: BorderRadius.circular(borderCircular ?? 20)),
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          elevation: WidgetStateProperty.all<double>(0),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                borderCircular ?? 20,
              ),
            ),
          ),
        ),
        child: Text(title!,
            style: kButton.copyWith(
                color: fontColor,
                fontSize: fontSize,
                fontWeight: fontWeight ?? FontWeight.normal)),
      ),
    );
  }
}
