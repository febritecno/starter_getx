import 'package:flutter/material.dart';
import 'package:absen/shared/theme.dart';

class CircleLoading extends StatelessWidget {
  final double sizeHeight, strokeWidth;
  final Color? color, backroundColor;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const CircleLoading(
      {this.sizeHeight = 60,
      this.mainAxisAlignment = MainAxisAlignment.center,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.color,
      this.strokeWidth = 1.2,
      this.backroundColor});

  @override
  Widget build(BuildContext context) {
    final height = (MediaQuery.of(context).size.height);
    final width = (MediaQuery.of(context).size.width);
    return SizedBox(
      child: Column(
        children: [
          CircularProgressIndicator(
            backgroundColor: backroundColor ?? Colors.grey[300],
            color: color ?? kBlueColor,
            strokeWidth: height * strokeWidth / 100,
          )
        ],
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
      ),
      width: width,
      height: sizeHeight,
    );
  }
}
