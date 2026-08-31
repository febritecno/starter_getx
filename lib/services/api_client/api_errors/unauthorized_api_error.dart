import 'package:dio/dio.dart';
import 'package:logistika/shared/constants.dart';

class UnauthorizedApiError extends DioException {
  UnauthorizedApiError()
      : super(requestOptions: RequestOptions(path: BASE_URL));
}
