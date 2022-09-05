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

  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: Image(
                image: NetworkImage(
                    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png")),
            accountName: Text("Sahretech"),
            accountEmail: Text("ig: @sahretech"),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://cdn.pixabay.com/photo/2016/04/24/20/52/laundry-1350593_960_720.jpg"),
                    fit: BoxFit.cover)),
          ),
          ListTile(
            leading: Icon(Icons.manage_accounts_sharp),
            title: Text("My Account"),
            onTap: () {
              Get.back();
            },
          ),
          ListTile(
            leading: Icon(Icons.switch_account_sharp),
            title: Text("Booking"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.screenshot_monitor_outlined),
            title: Text("Operational Monitoring"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.query_stats_outlined),
            title: Text("Tarif Info"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.currency_exchange),
            title: Text("Invoice"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.file_present_rounded),
            title: Text("List Hold Amount"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.document_scanner),
            title: Text("List Proforma (DP)"),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
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
      drawer: _drawer(),
    );
  }
}
