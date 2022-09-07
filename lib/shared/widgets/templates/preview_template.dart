import 'package:absen/shared/constants.dart';
import 'package:flutter/material.dart';

class PreviewTemplate extends StatelessWidget {
  const PreviewTemplate({Key? key, this.image}) : super(key: key);

  final String? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4),
      body: Center(
        child: FadeInImage(
          fit: BoxFit.fitWidth,
          image: NetworkImage(image!),
          placeholder: AssetImage(NO_IMAGE),
          imageErrorBuilder: (context, error, stackTrace) =>
              Image.asset(NO_IMAGE),
        ),
      ),
    );
  }
}
