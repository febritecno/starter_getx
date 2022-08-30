import 'dart:async';

import 'package:logistika/helpers/third_party/sizer/sizer.dart';
import 'package:logistika/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckAuthScreen extends StatefulWidget {
  final PageRoute loginScreen;
  final PageRoute landingScreen;

  CheckAuthScreen({required this.loginScreen, required this.landingScreen});

  _CheckAuthScreenState createState() => _CheckAuthScreenState();
}

class _CheckAuthScreenState extends State<CheckAuthScreen> {
  Future _checkFirstSeen() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? tokenKey = _prefs.getString('token_key');

    try {
      if (tokenKey.toString() == "null") {
        _prefs.setString('token_key', 'null');
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
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(ICON_PATH + "splash_logo.png", width: 35.w),
        ],
      ),
    );
  }
}
