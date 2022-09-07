import 'package:absen/helpers/third_party/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:absen/helpers/third_party/sizer/sizer.dart';

class BoxSkeleton extends StatelessWidget {
  final double? height;
  final double? width;
  final double? radius;
  const BoxSkeleton({Key? key, this.height, this.width, this.radius})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade500,
        highlightColor: Colors.grey.shade600,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(radius ?? 12)),
              color: Colors.grey),
          height: height ?? 30.h,
          width: width ?? Get.width,
        ),
      ),
    );
  }
}
