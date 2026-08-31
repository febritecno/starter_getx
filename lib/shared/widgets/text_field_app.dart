import 'package:myapp/helpers/helpers.dart';
import 'package:myapp/helpers/third_party/sizer/sizer.dart';
import 'package:myapp/shared/widgets/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldApp extends StatelessWidget {
  final Function(String)? onChanged;
  final TextStyle? placeholderStyle;
  final Color? color;
  final Widget? suffix, prefix;
  final String? label, initialValue, placeholder, hintText;
  final FontWeight? fontWeight;
  final Alignment? suffixAlign, prefixAlign;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final double? labelSize,
      fontSize,
      suffixSize,
      prefixSize,
      paddingHorizontal,
      paddingVertical;
  final int? maxLines, minLines;
  final TextInputAction? textInputAction;
  final bool? enabled, readOnly, isLabel, autofocus;
  final TextEditingController? controller;
  final EdgeInsets? contentPadding;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  const TextFieldApp(
      {super.key,
      this.label,
      this.suffix,
      this.prefix,
      this.fontWeight,
      this.labelSize,
      this.controller,
      this.initialValue,
      this.enabled,
      this.suffixSize,
      this.prefixSize,
      this.suffixIcon,
      this.contentPadding,
      this.fontSize,
      this.suffixAlign,
      this.prefixAlign,
      this.readOnly,
      this.paddingHorizontal,
      this.paddingVertical,
      this.isLabel = true,
      this.placeholder,
      this.hintText,
      this.keyboardType,
      this.inputFormatters,
      this.autofocus,
      this.onChanged,
      this.maxLines,
      this.textInputAction,
      this.minLines,
      this.color,
      this.prefixIcon,
      this.placeholderStyle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: paddingVertical ?? 0.hp,
        bottom: paddingVertical ?? 3.hp,
        left: paddingHorizontal ?? 0.wp,
        right: paddingHorizontal ?? 0.wp,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (isLabel == true)
              ? TextApp(label ?? 'label',
                  color: Colors.grey,
                  fontWeight: fontWeight ?? FontWeight.bold,
                  fontSize: labelSize ?? 14.spp)
              : Container(),
          Stack(
            children: [
              TextFormField(
                cursorColor: Colors.black,
                minLines: minLines ?? 1,
                maxLines: maxLines ?? 1,
                textInputAction: textInputAction ?? TextInputAction.done,
                onChanged: onChanged,
                autofocus: autofocus ?? false,
                readOnly: readOnly ?? false,
                controller: controller,
                style: TextStyle(
                    color: color ?? Colors.grey,
                    fontWeight: fontWeight ?? FontWeight.w400,
                    fontSize: fontSize ?? 14.spp),
                initialValue: initialValue,
                decoration: InputDecoration(
                  hintText: hintText,
                  enabled: enabled ?? true,
                  labelText: placeholder,
                  labelStyle: placeholderStyle,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  suffix: SizedBox(width: suffixSize ?? 0),
                  prefix: SizedBox(width: prefixSize ?? 0),
                  suffixIcon: suffixIcon,
                  prefixIcon: prefixIcon,
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  fillColor: Colors.white,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  contentPadding: contentPadding ??
                      EdgeInsets.symmetric(horizontal: 0.hp, vertical: 1.hp),
                ),
                keyboardType: keyboardType ?? TextInputType.text,
                inputFormatters: inputFormatters ?? [],
              ),
              SizedBox(
                height: 5.hp,
                width: Helpers.width(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: prefixSize ?? 0,
                      child: Align(
                        alignment: prefixAlign ?? Alignment.bottomCenter,
                        child: prefix,
                      ),
                    ),
                    SizedBox(
                      width: suffixSize ?? 0,
                      child: Align(
                          alignment: suffixAlign ?? Alignment.bottomCenter,
                          child: suffix),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
