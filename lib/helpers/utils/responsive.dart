import 'package:flutter/widgets.dart';
import 'package:myapp/helpers/third_party/sizer/sizer.dart';

/// Adaptive helpers for one-codebase multiplatform UI. Built on Sizer (which
/// `main.dart` initialises), so these read the live device class/size.
///
/// Two layers of adaptivity, used together:
/// 1. **Sizer** (`.w/.h/.sp/.r`) scales every size proportionally — the default.
/// 2. **Breakpoints** (below) switch *layout* when scaling isn't enough — e.g.
///    1 column on phone → 2 on tablet → 3 on desktop.
///
/// ```dart
/// // pick a value by width class
/// final cols = context.responsive(phone: 1, tablet: 2, desktop: 3);
/// // or branch layout
/// if (context.isTablet) return _wide(); else return _narrow();
/// ```
class Breakpoints {
  static const double tablet = 600; // < 600 = phone
  static const double desktop = 1024; // >= 1024 = desktop
}

/// Coarse width class, independent of platform — a large tablet and a small
/// desktop window are treated the same for layout decisions.
enum ScreenClass { phone, tablet, desktop }

extension ResponsiveContext on BuildContext {
  double get screenW => SizerUtil.width;
  double get screenH => SizerUtil.height;
  bool get isPortrait => SizerUtil.orientation == Orientation.portrait;
  bool get isLandscape => SizerUtil.orientation == Orientation.landscape;

  ScreenClass get screenClass {
    final w = SizerUtil.width;
    if (w >= Breakpoints.desktop) return ScreenClass.desktop;
    if (w >= Breakpoints.tablet) return ScreenClass.tablet;
    return ScreenClass.phone;
  }

  bool get isPhone => screenClass == ScreenClass.phone;
  bool get isTablet => screenClass == ScreenClass.tablet;
  bool get isDesktop => screenClass == ScreenClass.desktop;

  /// True on a real desktop/web platform (vs a tablet-sized phone window).
  bool get isDesktopPlatform =>
      SizerUtil.deviceType == DeviceType.web ||
      SizerUtil.deviceType == DeviceType.mac ||
      SizerUtil.deviceType == DeviceType.windows ||
      SizerUtil.deviceType == DeviceType.linux;

  /// Pick a value per width class. `tablet`/`desktop` fall back to the smaller
  /// class when omitted, so you only specify what actually differs.
  T responsive<T>({required T phone, T? tablet, T? desktop}) {
    switch (screenClass) {
      case ScreenClass.desktop:
        return desktop ?? tablet ?? phone;
      case ScreenClass.tablet:
        return tablet ?? phone;
      case ScreenClass.phone:
        return phone;
    }
  }

  /// Cap content width on large screens so lines don't stretch edge-to-edge.
  /// Wrap a page body: `Center(child: ConstrainedBox(constraints: BoxConstraints(maxWidth: context.contentMaxWidth), child: ...))`.
  double get contentMaxWidth => isDesktop ? 1100 : (isTablet ? 720 : screenW);
}
