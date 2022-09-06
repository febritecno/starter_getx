import 'package:get/get.dart';
import 'package:logistika/routes/app_adapters.dart';

class HomeController extends GetxController {
  final IDashboardRepository repository;
  HomeController({required this.repository});

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }
}
