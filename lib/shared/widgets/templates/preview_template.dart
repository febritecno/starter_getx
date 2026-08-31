import 'package:myapp/shared/constants.dart';
import 'package:flutter/material.dart';

class PreviewTemplate extends StatelessWidget {
  const PreviewTemplate({super.key, this.image});

  final String? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.4),
      body: Center(
        child: FadeInImage(
          fit: BoxFit.fitWidth,
          image: NetworkImage(image!),
          placeholder: AssetImage(NO_IMAGE),
          imageErrorBuilder: (context, error, stackTrace) =>
              Image.asset(DEFAULT_IMAGE),
        ),
      ),
    );
  }
}
