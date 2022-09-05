import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logistika/helpers/third_party/sizer/sizer.dart';
import 'package:logistika/shared/theme.dart';
import 'package:logistika/shared/widgets/text_app.dart';
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
                    child: Icon(Icons.menu, color: Colors.white),
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
              height: 30.h,
              child: GridView(
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
        ],
      ),
    );
  }

  Widget _body() {
    return Column();
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
            leading: Icon(Icons.manage_accounts_sharp,
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
    final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

    return Scaffold(
      key: _key,
      body: Column(
        children: [
          Stack(
            children: [
              Container(color: kDarkBlueColor, height: 50.h),
              _header({'key': _key})
            ],
          ),
          Container(
            color: kGreyColor,
            child: _body(),
          ),
        ],
      ),
      drawer: _drawer({'key': _key}),
    );
  }
}
