import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistika/helpers/third_party/sizer/sizer.dart';
import 'package:logistika/shared/theme.dart';
import 'package:logistika/shared/widgets/text_app.dart';
import '../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  _header() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.menu, color: Colors.white),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextApp(
                          "Olivia Puspita",
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: bold,
                        ),
                        TextApp(
                          "Admin",
                          color: Colors.white,
                          fontSize: 8.sp,
                        ),
                      ],
                    ),
                    SizedBox(width: 1.w),
                    Icon(Icons.account_circle, size: 6.w, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
          Container(
              height: 20.h,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(14)))),
          Container(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              height: 30.h,
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 4,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  crossAxisCount: 2,
                ),
                children: [
                  Card(
                      color: kBlueColor,
                      child: Row(
                        children: [
                          SizedBox(width: 2.w),
                          Icon(Icons.directions_boat_rounded,
                              color: Colors.white),
                          SizedBox(width: 2.w),
                          TextApp("Port Services",
                              color: Colors.white, maxLines: 2),
                        ],
                      )),
                  Card(
                      color: kBlueColor,
                      child: Row(
                        children: [
                          SizedBox(width: 2.w),
                          Icon(Icons.local_shipping_rounded,
                              color: Colors.white),
                          SizedBox(width: 2.w),
                          TextApp("Transpotation Services",
                              color: Colors.white, maxLines: 2),
                        ],
                      )),
                  Card(
                      color: kBlueColor,
                      child: Row(
                        children: [
                          SizedBox(width: 2.w),
                          Icon(Icons.home_filled, color: Colors.white),
                          SizedBox(width: 2.w),
                          TextApp("Warehouse Services",
                              color: Colors.white, maxLines: 2),
                        ],
                      )),
                  Card(
                      color: kBlueColor,
                      child: Row(
                        children: [
                          SizedBox(width: 2.w),
                          Icon(Icons.local_airport_rounded,
                              color: Colors.white),
                          SizedBox(width: 2.w),
                          TextApp("Air Cargo Services",
                              color: Colors.white, maxLines: 2),
                        ],
                      )),
                ],
              )),
        ],
      ),
    );
  }

  _body() {
    return Column();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(color: kDarkBlueColor, height: 50.h),
              _header()
            ],
          ),
          Container(
            color: kGreyColor,
            child: _body(),
          ),
        ],
      ),
    );
  }
}
