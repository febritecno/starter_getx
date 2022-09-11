import 'package:absen/modules/home/controllers/attendance_controller.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class DashboardController extends GetxController {
  var tabIndex = 0;

  void changeTabIndex(int index) {
    tabIndex = index;
    print("menu ke $tabIndex");
    switch (tabIndex) {
      case 0:
        Get.find<HomeController>().onInit();
        break;
      case 1:
        Get.find<AttendanceController>().onInit();
        break;
    }
    update();
  }

  @override
  void onInit() {
    changeTabIndex(0);
    super.onInit();
  }
}
