import 'dart:async';

import 'package:myapp/helpers/third_party/sizer/sizer.dart';
import 'package:myapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckAuthScreen extends StatefulWidget {
  final PageRoute loginScreen;
  final PageRoute landingScreen;

  const CheckAuthScreen({super.key, required this.loginScreen, required this.landingScreen});

  @override
  _CheckAuthScreenState createState() => _CheckAuthScreenState();
}

class _CheckAuthScreenState extends State<CheckAuthScreen> {
  Future _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenKey = prefs.getString('token_key');
    if (!mounted) return;

    try {
      if (tokenKey.toString() == "null") {
        prefs.setString('token_key', 'null');
        Navigator.of(context).pushReplacement(widget.loginScreen);
      } else {
        Navigator.of(context).pushReplacement(widget.landingScreen);
      }
    } catch (e) {
      Navigator.of(context).pushReplacement(widget.landingScreen);
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      _checkFirstSeen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 1],
          colors: [
            Colors.white,
            Color(0xff2575AB),
          ],
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('${IMAGE_PATH}app_logo.png', width: 60.wp),
          ],
        ),
      ),
    );
  }
}
