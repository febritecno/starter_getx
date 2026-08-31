import 'package:dio/dio.dart';
import 'package:myapp/services/api_client/api_client.dart';
import 'package:myapp/services/exceptions/server_exception.dart';
import 'package:myapp/shared/constants.dart';

/// Sample data source for the dashboard news feed. Wraps [ApiClient] and
/// rethrows failures as [ServerException]. Add new endpoints here.
class DashboardRepository {
  final ApiClient apiClient;
  DashboardRepository({required this.apiClient});

  Future<Response?> getNews({int limit = 20}) async {
    try {
      final response = await apiClient.get("$NEWS_URL/articles/?limit=$limit");
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }
}
