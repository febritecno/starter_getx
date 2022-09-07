import 'package:absen/helpers/third_party/sizer/sizer.dart';
import 'package:absen/shared/theme.dart';
import 'package:absen/shared/widgets/text_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBottomSheet {
  static void custom(children, {isFull = false}) {
    Get.bottomSheet(
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: Material(
            child: Container(
              color: Colors.white,
              // height autosize with wrap
              child: Wrap(
                children: children,
              ),
            ),
          ),
        ),
        isDismissible: true,
        isScrollControlled: isFull);
  }

  static void show(
      {required String title,
      List<Widget>? children,
      Widget? custom,
      isFull = false}) {
    Get.bottomSheet(
        // safe-area bottomSheet
        Padding(
          padding: EdgeInsets.only(
              top: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                  .padding
                  .top),
          child: Material(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Icon(Icons.close, color: Colors.grey),
                        ),
                      ),
                      Center(
                        child: TextApp(
                          "$title",
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: custom ??
                      SingleChildScrollView(
                        child: Column(
                          children: children ?? [],
                        ),
                      ),
                ),
              ],
            ),
          ),
        ),
        isScrollControlled: isFull);
  }

  /// use builder for lazy rendering on demand
  static void list(
      {required String title,
      required Function? items,
      required itemLenght,
      isFull = false}) {
    Get.bottomSheet(
        Material(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Icon(Icons.close, color: Colors.grey),
                      ),
                    ),
                    Center(
                      child: TextApp(
                        "$title",
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (_, index) => items!(index),
                  itemCount: itemLenght,
                ),
              ),
            ],
          ),
        ),
        isScrollControlled: false);
  }
}

class ListBottomSheet extends StatelessWidget {
  const ListBottomSheet({Key? key, required this.title, required this.onTap})
      : super(key: key);

  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: TextApp(title, fontSize: 16.sp, fontWeight: FontWeight.w600),
          onTap: () async {
            await onTap();
            Get.back();
          },
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultMargin.w),
            child: Divider(height: 1.h, color: Colors.grey.shade300)),
      ],
    );
  }
}

class HeaderBottomSheet extends StatelessWidget {
  final dynamic height;
  const HeaderBottomSheet({Key? key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(2.w),
          child: Center(
            child: Container(
              height: 0.8.h,
              width: 14.w,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        SizedBox(height: height ?? 4.h),
      ],
    );
  }
}
