import 'package:logistika/helpers/third_party/sizer/sizer.dart';
import 'package:logistika/shared/theme.dart';
import 'package:logistika/shared/widgets/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppbarTemplate extends StatelessWidget {
  const AppbarTemplate(
      {Key? key,
      this.children,
      this.weight,
      required this.title,
      this.isCenter = true,
      this.isCustom = false,
      this.body,
      this.onBack})
      : super(key: key);

  final List<Widget>? children;
  final String title;
  final double? weight;
  final bool? isCenter;
  final bool? isCustom;
  final Widget? body;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: kBlueColor),
            title: TextApp(
              title,
              fontSize: defaultAppbarTitle,
              fontWeight: FontWeight.bold,
            ),
            centerTitle: isCenter,
            elevation: 0,
            leading: IconButton(
              color: Colors.grey.shade300,
              onPressed: onBack ?? () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, color: Colors.black),
            ),
            backgroundColor: Colors.white,
          ),
          body: isCustom == false
              ? Container(
                  color: Colors.white,
                  height: double.infinity,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: weight ?? defaultMargin.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: children!,
                      ),
                    ),
                  ),
                )
              : body,
        ),
      ),
    );
  }
}
