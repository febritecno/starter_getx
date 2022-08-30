import 'package:dio/dio.dart';
import 'package:logistika/shared/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_error_message_error.g.dart';

class ApiErrorMessageError extends DioError {
  @JsonKey(name: 'error_message')
  final String errorMessage;

  @JsonKey(ignore: true)
  RequestOptions request;

  // @override
  // @JsonKey(ignore: true)
  // Response? response;
  //
  // @override
  // @JsonKey(ignore: true)
  // DioErrorType type;
  //
  // @override
  // @JsonKey(ignore: true)
  // dynamic error;

  //
  // ApiErrorMessageError({
  //   required this.errorMessage,
  //   required this.request,
  //   required this.response,
  //   required this.type,
  //   required this.error,
  // });

  ApiErrorMessageError({
    required this.errorMessage,
    required this.request,
  }) : super(requestOptions: request);

  factory ApiErrorMessageError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorMessageErrorFromJson(json);
}
