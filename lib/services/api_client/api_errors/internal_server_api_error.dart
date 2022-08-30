import 'package:dio/dio.dart';
import 'package:logistika/shared/constants.dart';

class InternalServerApiError extends DioError {
  InternalServerApiError()
      : super(requestOptions: RequestOptions(path: BASE_URL));
}
