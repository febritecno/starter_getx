import 'package:absen/modules/geotag/controllers/geotag_controller.dart';
import 'package:absen/modules/home/controllers/attendance_controller.dart';
import 'package:absen/modules/home/controllers/dashboard_controller.dart';
import 'package:absen/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => GeotagController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => AttendanceController());
  }
}
