import 'package:flutter/material.dart';

//* VARIABLES
const double defaultMargin = 4;
const double defaultRadius = 5;
const double defaultAppbarTitle = 26;

//* COLORS
const Color kBlackBlueColor = Color(0xff163549);
const Color kDarkBlueColor = Color(0xff144668);
const Color kSemiBlueColor = Color(0xff2575AB);
const Color kLightBlueColor = Color(0xff4A90BF);
const Color kBlueColor = Color(0xff2687C9);
const Color kRedColor = Color(0xffFF0000);
const Color kOrangeColor = Color(0xffFF9900);
const Color kGreenColor = Color(0xff35A632);
const Color kDarkGreyColor = Color(0xff858585);
const Color kGreyColor = Color(0xffDADADA);
const Color kLightGreyColor = Color(0xffE3E3E3);
const Color kdarkGreyColor = Color(0xff4F4F4F);

//* FONT STYLES
const String defaultFont = 'lato';
const double defaultTextSize = 14;
const double defaultTextLineHeight = 1.2;
//
// font weight
//
const FontWeight light = FontWeight.w300;
const FontWeight regular = FontWeight.w400;
const FontWeight medium = FontWeight.w500;
const FontWeight semiBold = FontWeight.w600;
const FontWeight bold = FontWeight.w700;
const FontWeight extraBold = FontWeight.w800;
const FontWeight black = FontWeight.w900;
//
// font styles
//
TextStyle headerTextStyle =
    TextStyle(color: kDarkBlueColor, decoration: TextDecoration.none);
TextStyle subTextStyle =
    TextStyle(color: kDarkGreyColor, decoration: TextDecoration.none);
//
// font text scaling
//
const Map<String, double> textScale = {
  'table': 0.65,
  'phone': 0.75,
  'largeTablet': 0.60,
  'dafault': 0.70
};
