import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class DashboardController extends GetxController {
  var tabIndex = 0;

  void changeTabIndex(int index) {
    tabIndex = index;
    debugPrint("menu ke $tabIndex");
    if (tabIndex != 0) {
      switch (tabIndex) {
        case 1:
          // Get.find<GroupController>().onInit();
          break;
        case 2:
          // Get.find<ReferensiController>().onInit();
          break;
        case 3:
          // Get.find<ProfileController>().onInit();
          break;
        default:
      }
    } else {
      Get.find<HomeController>();
    }
    update();
  }

  @override
  void onInit() {
    changeTabIndex(0);
    super.onInit();
  }
}
