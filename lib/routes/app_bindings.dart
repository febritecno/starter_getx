import 'package:get/get.dart';
import 'package:myapp/modules/auth/controllers/auth_controller.dart';
import 'package:myapp/modules/home/controllers/dashboard_controller.dart';
import 'package:myapp/modules/home/controllers/home_controller.dart';
import 'package:myapp/repository/auth_repository.dart';
import 'package:myapp/repository/dashboard_repository.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthRepository(apiClient: Get.find()));
    Get.lazyPut(() => AuthController(repository: Get.find()));
  }
}

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardRepository(apiClient: Get.find()));
    Get.lazyPut(() => HomeController(repository: Get.find()));
  }
}
