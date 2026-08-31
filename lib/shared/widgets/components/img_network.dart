import 'package:cached_network_image/cached_network_image.dart';
import 'package:logistika/shared/constants.dart';
import 'package:flutter/material.dart';

class ImgNetwork extends StatelessWidget {
  final double? loaderHeight;
  final double? loaderWidth;
  final double? loaderRadius;
  final String? defaultPath;
  final String url;
  final BoxFit? fit;
  const ImgNetwork(this.url,
      {Key? key,
      this.loaderHeight,
      this.loaderWidth,
      this.loaderRadius = 0,
      this.fit,
      this.defaultPath = NO_IMAGE})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit ?? BoxFit.cover,
      // progressIndicatorBuilder: (context, child, loadingProgress) {
      //   if (loadingProgress == null) return SizedBox();
      //   return Center(
      //       child: BoxSkeleton(
      //           height: loaderHeight,
      //           width: loaderWidth,
      //           radius: loaderRadius));
      // },
      errorWidget: (context, exception, stackTrace) {
        return Container(
          height: 200,
          color: Colors.grey.withOpacity(0.2),
          child: Center(child: Image.asset(defaultPath!, fit: BoxFit.fill)),
        );
      },
    );
  }
}
