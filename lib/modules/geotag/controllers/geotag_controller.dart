import 'package:absen/helpers/app_key.dart';
import 'package:absen/routes/routes.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:get/get.dart';

class GeotagController extends GetxController {
  var isLoading = false.obs;
  var coord = [-6.200000, 106.816666].obs;
  var zoom = 14.obs;

  @override
  void onInit() {
    super.onInit();
  }

  pinMarker(MapPosition position) {
    coord([
      position.center!.latitude,
      position.center!.longitude,
    ]);
  }

  saveMasterLocation() async {
    await AppKey.setTargetLocation("${coord[0]},${coord[1]}");
    Get.toNamed(Routes.DASHBOARD);
  }
}
