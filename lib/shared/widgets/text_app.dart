import 'package:flutter/material.dart';
import 'package:logistika/shared/constants.dart';
import 'package:get/get.dart';

class TextApp extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextDirection? textDirection;
  final FontWeight? fontWeight;
  final double? fontSize, height;
  final String? fontFamily;
  final TextStyle? style;
  final Color? color;
  final FontStyle? fontStyle;
  final TextDecoration? textDecoration;
  final List<Shadow>? shadows;
  final EdgeInsets? padding;

  const TextApp(this.text,
      {Key? key,
      this.textAlign,
      this.style,
      this.maxLines,
      this.overflow,
      this.softWrap,
      this.textDirection,
      this.fontWeight,
      this.fontSize,
      this.fontFamily,
      this.color,
      this.fontStyle,
      this.textDecoration,
      this.shadows,
      this.padding,
      this.height});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.all(0),
      child: Text(
        text,
        key: key,
        textAlign: textAlign,
        maxLines: maxLines ?? 1,
        overflow: overflow ?? TextOverflow.ellipsis,
        softWrap: softWrap,
        textDirection: textDirection,
        textScaleFactor: context.isTablet
            ? 0.65
            : context.isPhone
                ? 0.75
                : context.isLargeTablet
                    ? 0.60
                    : 0.70,
        style: style ??
            TextStyle(
              decoration: textDecoration ?? TextDecoration.none,
              height: height ?? AppConfig.defaultTextLineHeight,
              fontWeight: fontWeight ?? FontWeight.normal,
              fontSize: fontSize ?? AppConfig.defaultTextSize,
              fontFamily: fontFamily ?? AppConfig.defaultFont,
              color: color ?? Colors.black,
              fontStyle: fontStyle ?? FontStyle.normal,
            ),
      ),
    );
  }
}
