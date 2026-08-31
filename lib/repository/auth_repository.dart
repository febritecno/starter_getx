import 'package:dio/dio.dart';
import 'package:myapp/services/api_client/api_client.dart';
import 'package:myapp/services/exceptions/server_exception.dart';
import 'package:myapp/shared/constants.dart';

class AuthRepository {
  final ApiClient apiClient;
  AuthRepository({required this.apiClient});

  Future<Response?> postLogin(Map body) async {
    try {
      final response = await apiClient.post(
        "$BASE_URL/auth/login",
        body,
        options: Options(contentType: Headers.jsonContentType),
      );
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }
}
