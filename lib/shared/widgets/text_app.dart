import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme.dart';

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
      {super.key,
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
        textScaler: TextScaler.linear((context.isTablet
                ? textScale['tablet']
                : context.isPhone
                    ? textScale['phone']
                    : context.isLargeTablet
                        ? textScale['largeTablet']
                        : textScale['dafault']) ??
            1.0),
        style: style ??
            TextStyle(
              decoration: textDecoration ?? TextDecoration.none,
              height: height ?? defaultTextLineHeight,
              fontWeight: fontWeight ?? FontWeight.normal,
              fontSize: fontSize ?? defaultTextSize,
              fontFamily: fontFamily ?? defaultFont,
              color: color ?? Colors.black,
              fontStyle: fontStyle ?? FontStyle.normal,
            ),
      ),
    );
  }
}
