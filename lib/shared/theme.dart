import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/helpers/third_party/sizer/sizer.dart';

//* VARIABLES
const double defaultMargin =
    4; // design px, used with .wp (e.g. defaultMargin.wp)
const double defaultRadius = 5;
double get defaultAppbarTitle => 20.sp; // scaled via sizer

/// One status-bar style for the whole app so it stays consistent across every
/// screen. Adapts to the device: light mode → dark icons; dark mode → light.
SystemUiOverlayStyle appOverlayStyle(Brightness platformBrightness) {
  final isDark = platformBrightness == Brightness.dark;
  return SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness:
        isDark ? Brightness.light : Brightness.dark, // Android
    statusBarBrightness: isDark ? Brightness.dark : Brightness.light, // iOS
  );
}

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
    const TextStyle(color: kDarkBlueColor, decoration: TextDecoration.none);
TextStyle subTextStyle =
    const TextStyle(color: kDarkGreyColor, decoration: TextDecoration.none);
//* TEXT STYLES — define once, reuse via `style: kBody` or the app TextTheme.
// Getters (not const) because `.sp` is resolved at runtime by Sizer. Use with
// raw `Text('x', style: kTitle)`; a bare `Text('x')` inherits `appTextTheme`
// (bodyMedium = kBody). This is the app's global text system — no per-widget font.
TextStyle get kH1 => TextStyle(
    fontFamily: defaultFont,
    fontSize: 24.sp,
    fontWeight: bold,
    height: defaultTextLineHeight,
    color: kBlackBlueColor);
TextStyle get kH2 => TextStyle(
    fontFamily: defaultFont,
    fontSize: 20.sp,
    fontWeight: bold,
    height: defaultTextLineHeight,
    color: kBlackBlueColor);
TextStyle get kTitle => TextStyle(
    fontFamily: defaultFont,
    fontSize: 16.sp,
    fontWeight: semiBold,
    height: defaultTextLineHeight,
    color: kBlackBlueColor);
TextStyle get kBody => TextStyle(
    fontFamily: defaultFont,
    fontSize: defaultTextSize.sp,
    fontWeight: regular,
    height: defaultTextLineHeight,
    color: Colors.black87);
TextStyle get kBodySm => TextStyle(
    fontFamily: defaultFont,
    fontSize: 12.sp,
    fontWeight: regular,
    height: defaultTextLineHeight,
    color: kDarkGreyColor);
TextStyle get kCaption => TextStyle(
    fontFamily: defaultFont,
    fontSize: 11.sp,
    fontWeight: regular,
    height: defaultTextLineHeight,
    color: kDarkGreyColor);
TextStyle get kButton => TextStyle(
    fontFamily: defaultFont,
    fontSize: defaultTextSize.sp,
    fontWeight: semiBold,
    height: 1.0,
    color: Colors.white);

/// THE app-bar title style — one size/weight for every screen's title so the
/// top bar reads identically app-wide. Override per screen via
/// `AppbarTemplate(titleStyle: ...)` only when a screen truly needs it.
TextStyle get kAppBarTitle => kH1.copyWith(fontSize: defaultAppbarTitle);

/// Wired into `appTheme.textTheme` so bare `Text` picks sensible defaults.
TextTheme get appTextTheme => TextTheme(
      displayLarge: kH1,
      headlineMedium: kH2,
      titleMedium: kTitle,
      bodyMedium: kBody,
      bodySmall: kBodySm,
      labelSmall: kCaption,
      labelLarge: kButton,
    );

//* RADII — scaled via Sizer (.r) for consistent rounding across screens.
double get rSm => 7.r;
double get rMd => 10.r;
double get rLg => 14.r;

//* APP THEME
// One ThemeData for the whole app, wired into GetMaterialApp in main.dart.
// Screens read colors/font from here (and from the k*Color tokens above) —
// never hardcode a hex or a font family inside a widget.
ThemeData get appTheme => ThemeData(
      useMaterial3: true,
      fontFamily: defaultFont,
      scaffoldBackgroundColor: Colors.white,
      textTheme: appTextTheme,
      colorScheme: ColorScheme.fromSeed(
        seedColor: kBlueColor,
        primary: kBlueColor,
        error: kRedColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: kDarkBlueColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      // Global field styling — raw `TextFormField` picks this up, so screens
      // don't restyle inputs. Override per-field only when truly needed.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        hintStyle: kBody.copyWith(color: kDarkGreyColor),
        labelStyle: kBody.copyWith(color: kDarkGreyColor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
          borderSide: const BorderSide(color: kGreyColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
          borderSide: const BorderSide(color: kBlueColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
          borderSide: const BorderSide(color: kRedColor),
        ),
      ),
      // Global primary button — raw `ElevatedButton` is consistent everywhere.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kBlueColor,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: kButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultRadius * 2),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: kBlueColor,
          textStyle: kButton.copyWith(color: kBlueColor),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: kBlueColor,
          side: const BorderSide(color: kBlueColor),
          textStyle: kButton.copyWith(color: kBlueColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultRadius * 2),
          ),
        ),
      ),
      // Uniform surfaces so raw Card / Divider / Chip / Dialog / Sheet / Snackbar
      // all look the same without per-screen styling.
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultRadius * 2),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: kLightGreyColor,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: kLightGreyColor,
        labelStyle: kBodySm,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultRadius * 4),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        titleTextStyle: kTitle,
        contentTextStyle: kBody,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultRadius * 3),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        contentTextStyle: kBody.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultRadius * 2),
        ),
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: kBlueColor),
    );
