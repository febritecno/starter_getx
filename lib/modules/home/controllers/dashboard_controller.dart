import 'package:get/get.dart';

class DashboardController extends GetxController {
  var tabIndex = 0;
  var isHideHeader = false;

  void changeTabIndex(int index) {
    tabIndex = index;
    print("menu ke $tabIndex");
    if (tabIndex != 0) {
      isHideHeader = false;
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
      isHideHeader = true;
      // Get.find<HomeController>().resetPost();
    }
    update();
  }

  @override
  void onInit() {
    changeTabIndex(0);
    // Get.find<AgendaController>();
    super.onInit();
  }
}
