import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:absen/helpers/third_party/sizer/sizer.dart';
import 'package:absen/shared/constants.dart';
import 'package:absen/shared/theme.dart';
import 'package:absen/shared/widgets/text_app.dart';
import '../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  Widget _header(data) {
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
                GestureDetector(
                    child: Icon(Icons.list, color: Colors.white),
                    onTap: () => data['key'].currentState!.openDrawer()),
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
              height: 15.h,
              child: GridView(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 4,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 4,
                  crossAxisCount: 2,
                ),
                children: [
                  Card(
                      color: kBlueColor,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          SizedBox(width: 3.w),
                          Icon(Icons.directions_boat_rounded,
                              color: Colors.white),
                          SizedBox(width: 2.w),
                          TextApp("Port Services",
                              fontWeight: bold,
                              color: Colors.white,
                              maxLines: 2),
                          SizedBox(width: 3.w),
                        ],
                      )),
                  Card(
                      color: kBlueColor,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          SizedBox(width: 3.w),
                          Icon(Icons.local_shipping_rounded,
                              color: Colors.white),
                          SizedBox(width: 2.w),
                          TextApp("Transpotation Services",
                              fontWeight: bold,
                              color: Colors.white,
                              maxLines: 2),
                          SizedBox(width: 3.w),
                        ],
                      )),
                  Card(
                      color: Colors.grey,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          SizedBox(width: 3.w),
                          Icon(Icons.home_filled, color: Colors.white),
                          SizedBox(width: 2.w),
                          TextApp("Warehouse Services",
                              color: Colors.white,
                              maxLines: 2,
                              fontWeight: bold),
                          SizedBox(width: 3.w),
                        ],
                      )),
                  Card(
                      color: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      elevation: 6,
                      child: Row(
                        children: [
                          SizedBox(width: 3.w),
                          Icon(Icons.local_airport_rounded,
                              color: Colors.white),
                          SizedBox(width: 2.w),
                          TextApp("Air Cargo Services",
                              color: Colors.white,
                              maxLines: 2,
                              fontWeight: bold),
                          SizedBox(width: 3.w),
                        ],
                      )),
                ],
              )),
          // Container(
          //   padding: EdgeInsets.symmetric(vertical: 1.h),
          //   height: 8.5.h,
          //   child: GridView(
          //     padding: EdgeInsets.zero,
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       childAspectRatio: 1.2,
          //       crossAxisSpacing: 40,
          //       mainAxisSpacing: 1,
          //       crossAxisCount: 4,
          //     ),
          //     children: [
          //       Card(
          //         color: kGreyColor,
          //         elevation: 6,
          //         shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(10)),
          //       ),
          //       Card(
          //         color: kGreyColor,
          //         elevation: 6,
          //         shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(10)),
          //       ),
          //       Card(
          //         color: kGreyColor,
          //         elevation: 6,
          //         shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(10)),
          //       ),
          //       Card(
          //         color: kGreyColor,
          //         elevation: 6,
          //         shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(10)),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _bodybadge({title, color, margin}) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 4.w),
      height: 2.5.h,
      width: 18.w,
      child: Center(
        child: TextApp("$title",
            color: Colors.white, fontWeight: bold, fontSize: 12.sp),
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
    );
  }

  Widget _body() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 18.h,
            width: 98.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _bodybadge(title: "Cargo", color: kOrangeColor),
                          SizedBox(
                            width: 70.w,
                            child: TextApp(
                              "30K DWT dry vessel opening Philippines, 30 July 2022",
                              maxLines: 2,
                              fontSize: 12.sp,
                              fontWeight: bold,
                              color: kdarkGreyColor,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _bodybadge(title: "Vessel", color: kSemiBlueColor),
                          SizedBox(
                            width: 70.w,
                            child: TextApp(
                              "Requirement to load 100000 MT Crude Philippines, 30 July 2022",
                              maxLines: 2,
                              fontSize: 12.sp,
                              fontWeight: bold,
                              color: kdarkGreyColor,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(8.sp),
                  margin: EdgeInsets.only(top: 2.sp),
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    width: 12.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextApp(
                          "More",
                          fontSize: 10.sp,
                          fontWeight: bold,
                          color: kDarkGreyColor,
                        ),
                        Container(
                          width: 4.w,
                          height: 4.w,
                          child: Center(
                              child: Icon(Icons.chevron_right_rounded,
                                  size: 10.sp, color: Colors.white)),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kDarkGreyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultMargin.w),
                child: TextApp(
                  "Ship Sales",
                  fontSize: 18.sp,
                  fontWeight: bold,
                  padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: defaultMargin.w),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                        6,
                        (index) => ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: SizedBox(
                                height: 30.w,
                                width: 30.w,
                                child: Card(
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                          '$IMAGE_PATH/Rectangle 4300 (1).png'),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _bodybadge(
                                              title: "Ready",
                                              color: kOrangeColor,
                                              margin: EdgeInsets.zero),
                                          Container(
                                            height: 5.h,
                                            alignment: Alignment.center,
                                            color: Colors.white,
                                            child: TextApp(
                                              "Container 66940 DWTWE 2006. built in",
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2.w),
                                              maxLines: 2,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _drawer(data) {
    return Drawer(
      backgroundColor: kSemiBlueColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 30.h,
            color: kBlackBlueColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => data['key'].currentState!.closeDrawer(),
                  child: Container(
                    padding: EdgeInsets.all(10.sp),
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.arrow_back_ios_rounded,
                        color: Colors.white, size: 16.sp),
                  ),
                ),
                Column(
                  children: [
                    Icon(Icons.account_circle_rounded,
                        color: Colors.white, size: 60.sp),
                    TextApp("Olivia Puspita",
                        fontWeight: extraBold,
                        color: Colors.white,
                        height: 2,
                        fontSize: 16.sp),
                    TextApp(
                      "Admin",
                      color: Colors.white,
                      fontSize: 14.sp,
                      height: 1.4,
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_box_rounded,
                color: Colors.white, size: 18.sp),
            title: TextApp(
              "My Account",
              fontSize: 14.sp,
              fontWeight: bold,
              color: Colors.white,
            ),
            onTap: () {
              Get.back();
            },
          ),
          Divider(color: kLightBlueColor, height: 0, thickness: 1),
          ListTile(
            leading: Icon(Icons.switch_account_sharp,
                color: Colors.white, size: 18.sp),
            title: TextApp(
              "Booking",
              fontSize: 14.sp,
              fontWeight: bold,
              color: Colors.white,
            ),
            onTap: () {},
          ),
          Divider(color: kLightBlueColor, height: 0, thickness: 1),
          ListTile(
            leading: Icon(Icons.screenshot_monitor_outlined,
                color: Colors.white, size: 18.sp),
            title: TextApp(
              "Operational Monitoring",
              fontSize: 14.sp,
              fontWeight: bold,
              color: Colors.white,
            ),
            onTap: () {},
          ),
          Divider(color: kLightBlueColor, height: 0, thickness: 1),
          ListTile(
            leading: Icon(Icons.query_stats_outlined,
                color: Colors.white, size: 18.sp),
            title: TextApp(
              "Tarif Info",
              fontSize: 14.sp,
              fontWeight: bold,
              color: Colors.white,
            ),
            onTap: () {},
          ),
          Divider(color: kLightBlueColor, height: 0, thickness: 1),
          ListTile(
            leading:
                Icon(Icons.currency_exchange, color: Colors.white, size: 18.sp),
            title: TextApp(
              "Invoice",
              fontSize: 14.sp,
              fontWeight: bold,
              color: Colors.white,
            ),
            onTap: () {},
          ),
          Divider(color: kLightBlueColor, height: 0, thickness: 1),
          ListTile(
            leading: Icon(Icons.file_present_rounded,
                color: Colors.white, size: 18.sp),
            title: TextApp(
              "List Hold Amount",
              fontSize: 14.sp,
              fontWeight: bold,
              color: Colors.white,
            ),
            onTap: () {},
          ),
          Divider(color: kLightBlueColor, height: 0, thickness: 1),
          ListTile(
            leading:
                Icon(Icons.document_scanner, color: Colors.white, size: 18.sp),
            title: TextApp(
              "List Proforma (DP)",
              fontSize: 14.sp,
              fontWeight: bold,
              color: Colors.white,
            ),
            onTap: () {},
          ),
          Divider(color: kLightBlueColor, height: 0, thickness: 1),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.white, size: 18.sp),
            title: TextApp(
              "Logout",
              fontSize: 14.sp,
              fontWeight: bold,
              color: Colors.white,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _key = GlobalKey();

    return Scaffold(
      key: _key,
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          Stack(
            children: [
              Container(color: kDarkBlueColor, height: 50.h),
              _header({'key': _key})
            ],
          ),
          _body(),
        ],
      ),
      drawer: _drawer({'key': _key}),
    );
  }
}
