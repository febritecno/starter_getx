import 'package:flutter/material.dart';
import 'package:myapp/shared/theme.dart';

class CircleLoading extends StatelessWidget {
  final double sizeHeight, strokeWidth;
  final Color? color, backroundColor;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const CircleLoading(
      {super.key, this.sizeHeight = 60,
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
      width: width,
      height: sizeHeight,
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          CircularProgressIndicator(
            backgroundColor: backroundColor ?? Colors.grey[300],
            color: color ?? kBlueColor,
            strokeWidth: height * strokeWidth / 100,
          )
        ],
      ),
    );
  }
}
