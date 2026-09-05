import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/helpers/app_key.dart';
import 'package:myapp/helpers/helpers.dart';
import 'package:myapp/helpers/system/snackbar.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'exceptions/exceptions.dart';

/// Single owner of network concerns: auth header injection, connection
/// guarding, error mapping and session invalidation. Repositories stay thin
/// and never deal with Dio errors directly.
class ApiClient {
  final Dio dio;

  ApiClient(this.dio) {
    dio.options
      ..connectTimeout = const Duration(minutes: 1)
      ..receiveTimeout = const Duration(minutes: 1);

    // Read the token per request so it stays fresh after login/logout.
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = AuthPrefs.getToken();
          if (token != null) options.headers['Authorization'] = token;
          handler.next(options);
        },
      ),
    );

    // Body-logging is expensive (serializes every payload) — debug only.
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          error: true,
          compact: true,
        ),
      );
    }
  }

  Future<Response?> get(String path, {Map<String, dynamic>? query}) => _send(
        () => dio.get(
          path,
          queryParameters: query,
          options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 500,
          ),
        ),
      );

  Future<Response?> post(String path, dynamic data, {Options? options}) =>
      _send(
        () => dio.post(
          path,
          data: data,
          options: options ??
              Options(contentType: Headers.formUrlEncodedContentType),
        ),
      );

  Future<Response?> put(String path, dynamic data,
          {Map<String, dynamic>? query}) =>
      _send(() => dio.put(path, data: data, queryParameters: query));

  Future<Response?> delete(String path, {Map<String, dynamic>? query}) =>
      _send(() => dio.delete(path, queryParameters: query));

  /// One entry point for every verb. No pre-flight connectivity ping — Dio
  /// already surfaces "no network" as [DioExceptionType.connectionError],
  /// so we map it here instead of paying a platform-channel round-trip per call.
  Future<Response?> _send(Future<Response> Function() request) async {
    try {
      return await _handleResponse(await request());
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.badResponse:
          return _handleResponse(e.response!);
        case DioExceptionType.connectionError:
          _notify(_ConnMessage.noInternet);
          throw BadNetworkException();
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          _notify(_ConnMessage.timeout);
          return null;
        default:
          _notify(_ConnMessage.error);
          return null;
      }
    }
  }

  /// 401/500 means the session is no longer valid: drop the token and surface
  /// the server message.
  Future<Response> _handleResponse(Response response) async {
    if (response.statusCode == 401 || response.statusCode == 500) {
      await Helpers.clearToken();
      final data = response.data;
      final message =
          (data is Map) ? (data['message'] ?? data['error'])?.toString() : null;
      if (message != null) AppSnackBar.info(message);
    }
    return response;
  }

  void _notify(_ConnMessage type) {
    switch (type) {
      case _ConnMessage.noInternet:
        AppSnackBar.dynamic(
          seconds: 4,
          backgroundColor: Colors.black54,
          title: 'No Internet Connection',
          icon: const Icon(Icons.wifi_tethering_off, color: Colors.white),
          message: 'Please check your network connection',
        );
        break;
      case _ConnMessage.timeout:
        AppSnackBar.dynamic(
          seconds: 4,
          backgroundColor: Colors.black54,
          title: 'Connection Timeout!',
          icon: const Icon(Icons.alarm_off, color: Colors.white),
          message: 'Please check your network connection',
        );
        break;
      case _ConnMessage.error:
        AppSnackBar.dynamic(
          seconds: 4,
          backgroundColor: Colors.black54,
          title: 'Connection Error!',
          icon:
              const Icon(Icons.running_with_errors_sharp, color: Colors.white),
          message: 'Request failed',
        );
        break;
    }
  }
}

enum _ConnMessage { noInternet, timeout, error }
