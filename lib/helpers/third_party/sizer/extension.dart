part of 'sizer.dart';

extension SizerExt on num {
  // ---------------------------------------------------------------------------
  // Percentage of screen (legacy). `20.hp` == 20% of screen height.
  // Use for proportional layout (half-screen headers, gutters, etc).
  // ---------------------------------------------------------------------------

  /// % of screen height.
  double get hp => this * SizerUtil.height / 100;

  /// % of screen width.
  double get wp => this * SizerUtil.width / 100;

  /// Legacy percentage-based font size.
  double get spp => this * (SizerUtil.width / 3) / 100;

  // ---------------------------------------------------------------------------
  // Design-pixel scaling (flutter_screenutil style). The number == the pixel
  // value from your design (baseline SizerUtil.designWidth x designHeight),
  // scaled proportionally to the real device. So `16.sp`, `24.w`, `12.r` read
  // exactly like the design spec but stay adaptive.
  // ---------------------------------------------------------------------------

  /// Width in design px, scaled by screen width.
  double get w => this * SizerUtil.scaleWidth;

  /// Height in design px, scaled by screen height.
  double get h => this * SizerUtil.scaleHeight;

  /// Font size in design px, scaled uniformly (min of width/height ratio).
  double get sp => this * SizerUtil.scaleText;

  /// Radius / square size in design px, scaled uniformly.
  double get r => this * SizerUtil.scaleText;
}
