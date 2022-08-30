import 'package:dio/dio.dart';
import 'package:logistika/shared/constants.dart';

class BadNetworkApiError extends DioError {
  BadNetworkApiError() : super(requestOptions: RequestOptions(path: BASE_URL));
}
