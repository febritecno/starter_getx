part of 'sizer.dart';

class SizerUtil {
  /// Device's BoxConstraints
  static late BoxConstraints boxConstraints;

  /// Device's Orientation
  static late Orientation orientation;

  /// Type of Device
  ///
  /// This can either be mobile or tablet
  static late DeviceType deviceType;

  /// Device's Height
  static late double height;

  /// Device's Width
  static late double width;

  /// Design baseline the pixel getters (`.w/.h/.sp/.r`) are authored against.
  /// Numbers you write == pixels on this reference frame, then scaled to the
  /// real device. Default: iPhone X logical size. Override in Sizer if needed.
  static double designWidth = 375;
  static double designHeight = 812;

  /// Scale factors from design -> device.
  static double get scaleWidth => width / designWidth;
  static double get scaleHeight => height / designHeight;

  /// Uniform scale (min of the two) — keeps fonts/radii from distorting or
  /// overflowing on tall/narrow or short/wide screens.
  static double get scaleText =>
      scaleWidth < scaleHeight ? scaleWidth : scaleHeight;

  /// Sets the Screen's size and Device's Orientation,
  /// BoxConstraints, Height, and Width
  static void setScreenSize(
      BoxConstraints constraints, Orientation currentOrientation) {
    // Sets boxconstraints and orientation
    boxConstraints = constraints;
    orientation = currentOrientation;

    // Sets screen width and height
    if (orientation == Orientation.portrait) {
      width = boxConstraints.maxWidth;
      height = boxConstraints.maxHeight;
    } else {
      width = boxConstraints.maxHeight;
      height = boxConstraints.maxWidth;
    }

    // Sets ScreenType
    if (kIsWeb) {
      deviceType = DeviceType.web;
    } else if (Platform.isAndroid || Platform.isIOS) {
      if ((orientation == Orientation.portrait && width < 600) ||
          (orientation == Orientation.landscape && height < 600)) {
        deviceType = DeviceType.mobile;
      } else {
        deviceType = DeviceType.tablet;
      }
    } else if (Platform.isMacOS) {
      deviceType = DeviceType.mac;
    } else if (Platform.isWindows) {
      deviceType = DeviceType.windows;
    } else if (Platform.isLinux) {
      deviceType = DeviceType.linux;
    } else {
      deviceType = DeviceType.fuchsia;
    }
  }

  //for responsive web
  static getWebResponsiveSize({smallSize, mediumSize, largeSize}) {
    return width < 600
        ? smallSize //'phone'
        : width >= 600 && width <= 1024
        ? mediumSize //'tablet'
        : largeSize; //'desktop';
  }
}

/// Type of Device
///
/// This can be either mobile or tablet
enum DeviceType { mobile, tablet, web, mac, windows, linux, fuchsia }
