import 'package:get/get.dart';
import 'package:myapp/modules/home/models/news_model.dart';
import 'package:myapp/repository/dashboard_repository.dart';

class HomeController extends GetxController {
  final DashboardRepository repository;
  HomeController({required this.repository});

  final isLoading = false.obs;
  final news = <NewsModel>[].obs;

  @override
  void onInit() {
    fetchNews();
    super.onInit();
  }

  Future<void> fetchNews() async {
    isLoading(true);
    try {
      final res = await repository.getNews(limit: 20);
      if (res?.statusCode == 200) {
        final results = (res!.data['results'] as List?) ?? [];
        news.assignAll(results.map((e) => NewsModel.fromJson(e)).toList());
      }
    } finally {
      isLoading(false);
    }
  }
}
