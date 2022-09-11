import 'package:absen/helpers/system/dialog.dart';
import 'package:absen/shared/widgets/components/rounded_button.dart';
import 'package:absen/shared/widgets/loading_app.dart';
import 'package:absen/shared/widgets/text_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:absen/shared/theme.dart';
import 'package:sizer/sizer.dart';
import '../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => LoadingApp(
          isLoading: controller.isLoading(),
          child: Scaffold(
            backgroundColor: Colors.grey.shade200,
            body: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(color: kDarkBlueColor, height: 30.h),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: defaultMargin.w),
                            height: Get.height / 1.40,
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 30,
                                    offset: Offset(
                                        0, 10), // changes position of shadow
                                  ),
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextApp(
                                        "Febrian Dwi Putra,",
                                        fontSize: 16.sp,
                                        fontWeight: semiBold,
                                      ),
                                      TextApp(
                                        "${controller.masterAttendance['date']}",
                                        fontSize: 16.sp,
                                        height: 1.4,
                                        fontWeight: semiBold,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    TextApp(
                                      "${controller.masterAttendance['time']}",
                                      fontSize: 60.sp,
                                      fontWeight: bold,
                                    ),
                                    TextApp(
                                      "${controller.masterAttendance['meter'] == 0 ? '---' : controller.masterAttendance['meter']} Meter",
                                      fontSize: 20.sp,
                                      fontWeight: bold,
                                      height: 1.6,
                                      color:
                                          (controller.masterAttendance['meter']
                                                      as int) >
                                                  50
                                              ? kRedColor
                                              : kGreenColor,
                                    ),
                                  ],
                                ),
                                RoundedButton(
                                  "Create Attendance",
                                  fontSize: 18.sp,
                                  fontWeight: bold,
                                  borderCircular: 18,
                                  onTap: () => AppDialog.showAlert(
                                    btnLeft: "Tidak",
                                    btnRight: "Iya",
                                    desc: "tidak bisa diubah setelah tersimpan",
                                    onBtnRight: () {
                                      Get.back();
                                      controller.submitAttendance();
                                    },
                                    title: "Apakah anda yakin ?",
                                  ),
                                  fontColor: Colors.white,
                                  color: kOrangeColor,
                                  linearGradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0, 1],
                                    colors: [
                                      kOrangeColor,
                                      Colors.orange.shade700
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
