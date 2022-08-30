import 'package:dio/dio.dart';
import 'package:logistika/shared/constants.dart';

class UnauthorizedApiError extends DioError {
  UnauthorizedApiError()
      : super(requestOptions: RequestOptions(path: BASE_URL));
}
