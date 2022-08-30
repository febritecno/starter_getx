import 'package:logistika/routes/app_adapters.dart';
import 'package:logistika/services/api_client/api_client.dart';
import 'package:logistika/services/exceptions/server_exception.dart';
import 'package:logistika/shared/constants.dart';

class AuthRepository extends IAuthRepository {
  final ApiClient apiClient;
  AuthRepository({required this.apiClient});

  @override
  Future postLogin(Map body) async {
    try {
      final response =
          await apiClient.post("$BASE_URL/API/?action=get_login", body);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future postRegister(Map body) async {
    try {
      final response =
          await apiClient.post("$BASE_URL/API/?action=insert_member", body);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }

  @override
  Future postForget(Map body) async {
    try {
      final response = await apiClient.post(
          "$BASE_URL/API/member.php?action=reset_password", body);
      return response;
    } catch (error, stacktrace) {
      throw ServerException(error.toString(), stacktrace);
    }
  }
}
