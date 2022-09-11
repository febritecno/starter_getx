import 'package:absen/modules/home/controllers/attendance_controller.dart';
import 'package:absen/shared/widgets/text_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:absen/shared/theme.dart';
import 'package:sizer/sizer.dart';

class AttendancePage extends GetView<AttendanceController> {
  const AttendancePage({Key? key}) : super(key: key);

  _attendance(data) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: defaultMargin.w, vertical: 1.h),
      height: 20.h,
      padding: EdgeInsets.symmetric(horizontal: defaultMargin.w, vertical: 2.h),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [TextApp("${data['date']}", fontSize: 12.sp)]),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: Icon(Icons.person_pin_circle_sharp,
                    size: 60.sp, color: kGreenColor),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextApp(
                        "Name",
                        fontSize: 14.sp,
                        fontWeight: semiBold,
                      ),
                      TextApp(
                        "Time",
                        fontSize: 14.sp,
                        height: 1.4,
                        fontWeight: semiBold,
                      ),
                      TextApp(
                        "Distance",
                        fontSize: 14.sp,
                        height: 1.4,
                        fontWeight: semiBold,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextApp(
                        "   :  Febrian Dwi Putra",
                        fontSize: 14.sp,
                        fontWeight: semiBold,
                      ),
                      TextApp(
                        "   :  ${data['time']}",
                        fontSize: 14.sp,
                        height: 1.4,
                        fontWeight: semiBold,
                      ),
                      TextApp(
                        "   :  ${data['meter']} meter",
                        fontSize: 14.sp,
                        height: 1.4,
                        fontWeight: semiBold,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _noData() {
    return Center(
      child: Container(
          margin:
              EdgeInsets.symmetric(horizontal: defaultMargin.w, vertical: 1.h),
          height: 50.w,
          padding:
              EdgeInsets.symmetric(horizontal: defaultMargin.w, vertical: 2.h),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 1,
                  offset: Offset(0, 2),
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(18))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.no_accounts_rounded,
                  color: Colors.black26, size: 80.sp),
              TextApp(
                "Empty",
                color: Colors.black38,
                height: 1.4,
                fontSize: 20.sp,
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(color: kDarkBlueColor, height: 50.h),
                controller.attendanceData.isEmpty
                    ? _noData()
                    : ListView.builder(
                        padding: EdgeInsets.only(top: 8.h, bottom: 6.h),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) => _attendance({
                          'date': controller.attendanceData[index].date,
                          'time': controller.attendanceData[index].time,
                          'meter': controller.attendanceData[index].meter
                        }),
                        itemCount: controller.attendanceData.length,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
