import 'package:dio/dio.dart';
import 'package:logistika/shared/constants.dart';

class BadNetworkApiError extends DioException {
  BadNetworkApiError() : super(requestOptions: RequestOptions(path: BASE_URL));
}
