import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myapp/helpers/third_party/sizer/sizer.dart';
import 'package:myapp/shared/theme.dart';

/// THE single screen foundation. Every screen is built from this — it
/// centralises status-bar style, SafeArea, background and the app bar so pages
/// never re-implement them. There is no separate `Scaffold`/`AppBar` wrapper.
///
/// Usage:
/// - Standard titled screen: `AppbarTemplate(title: 'Account', body: ...)`.
/// - Root/tab screen (no back button): `AppbarTemplate(title: 'X', showBack: false, ...)`.
/// - Custom-header screen (login, splash): `AppbarTemplate(showAppBar: false, body: ...)`.
/// - Scrolling form: pass [children] (built into a padded scroll view) instead of [body].
class AppbarTemplate extends StatelessWidget {
  const AppbarTemplate({
    super.key,
    this.title,
    this.children,
    this.weight,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.isCenter = true,
    this.isCustom = false,
    this.body,
    this.onBack,
    this.showAppBar = true,
    this.showBack = true,
    this.actions,
    this.bottom,
    this.backgroundColor,
    this.appBarColor,
    this.canPop = true,
    this.titleStyle,
    this.titleWidget,
    this.leading,
    this.systemOverlayStyle,
    this.bottomSafe = true,
    this.resizeToAvoidBottomInset,
  });

  final String? title;
  final List<Widget>? children;
  final double? weight;

  /// Padding for the [children] scroll view. Defaults to horizontal [weight]
  /// (or [defaultMargin]).
  final EdgeInsetsGeometry? padding;

  /// Column alignment for the [children] scroll view. Use
  /// [CrossAxisAlignment.stretch] for full-width buttons/inputs.
  final CrossAxisAlignment crossAxisAlignment;
  final bool isCenter;

  /// When true (or when [body] is given), [body] is used verbatim; otherwise
  /// [children] are wrapped in a padded scroll view.
  final bool isCustom;
  final Widget? body;
  final VoidCallback? onBack;

  /// Hide the app bar for screens that draw their own header.
  final bool showAppBar;
  final bool showBack;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final Color? appBarColor;
  final bool canPop;

  /// Override the shared [kAppBarTitle] style for this one screen (rare).
  final TextStyle? titleStyle;

  /// Full-custom title (logo, search field). Wins over [title].
  final Widget? titleWidget;

  /// Custom leading widget — wins over the default back button.
  final Widget? leading;

  /// Override the adaptive status-bar overlay for this screen (rare).
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Keep the body clear of the bottom notch/home-indicator (iOS + Android).
  final bool bottomSafe;
  final bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final overlay = systemOverlayStyle ??
        appOverlayStyle(MediaQuery.platformBrightnessOf(context));

    final Widget content = (isCustom || body != null)
        ? (body ?? const SizedBox.shrink())
        : SingleChildScrollView(
            padding: padding ??
                EdgeInsets.symmetric(horizontal: weight ?? defaultMargin.wp),
            child: Column(
              crossAxisAlignment: crossAxisAlignment,
              children: children ?? const [],
            ),
          );

    return PopScope(
      canPop: canPop,
      child: Scaffold(
        backgroundColor: backgroundColor ?? Colors.white,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: showAppBar
            ? AppBar(
                systemOverlayStyle: overlay,
                backgroundColor: appBarColor ?? Colors.white,
                elevation: 0,
                centerTitle: isCenter,
                title: titleWidget ??
                    (title == null
                        ? null
                        : Text(title!, style: titleStyle ?? kAppBarTitle)),
                leading: leading ??
                    (showBack
                        ? IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.black),
                            onPressed: onBack ?? () => Get.back(),
                          )
                        : null),
                actions: actions,
                bottom: bottom,
              )
            : null,
        // App bar insets the top; pad top ourselves only when it's absent.
        // Bottom SafeArea protects the iOS home-indicator / Android nav bar.
        body: SafeArea(top: !showAppBar, bottom: bottomSafe, child: content),
      ),
    );
  }
}
