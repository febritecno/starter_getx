import 'package:myapp/helpers/third_party/shimmer.dart';
import 'package:myapp/helpers/third_party/sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoxSkeleton extends StatelessWidget {
  final double? height;
  final double? width;
  final double? radius;
  const BoxSkeleton({super.key, this.height, this.width, this.radius});
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
          height: height ?? 30.hp,
          width: width ?? Get.width,
        ),
      ),
    );
  }
}
