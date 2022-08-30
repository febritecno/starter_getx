import 'package:dio/dio.dart';
import 'package:logistika/modules/auth/controllers/auth_controller.dart';
import 'package:logistika/modules/home/controllers/dashboard_controller.dart';
import 'package:logistika/modules/home/controllers/home_controller.dart';
import 'package:logistika/repository/auth_repository.dart';
import 'package:logistika/repository/dashboard_repository.dart';
import 'package:logistika/routes/app_adapters.dart';
import 'package:logistika/services/api_client/api_client.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient(Dio()));
    Get.lazyPut<IAuthRepository>(() => AuthRepository(apiClient: Get.find()));
    Get.lazyPut(() => AuthController(repository: Get.find()));
  }
}

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
  }
}

// HOME
//
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient(Dio()));
    Get.lazyPut<IDashboardRepository>(
        () => DashboardRepository(apiClient: Get.find()));
    Get.lazyPut(() => HomeController(repository: Get.find()));
  }
}
