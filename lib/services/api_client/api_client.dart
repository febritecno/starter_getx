import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logistika/helpers/app_key.dart';
import 'package:flutter/material.dart';
import 'package:logistika/helpers/helpers.dart';
import 'package:logistika/helpers/system/snackbar.dart';
import 'package:logistika/helpers/utils/connection_utils.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_errors/api_error_message_error.dart';
import 'api_errors/bad_network_api_error.dart';
import 'api_errors/internal_server_api_error.dart';
import 'api_errors/unauthorized_api_error.dart';
import 'exceptions/exceptions.dart';

class ApiClient {
  final Dio dio;

  ApiClient(this.dio) {
    dio.options.headers["Authorization"] = AuthPrefs.getToken();
    dio.options.connectTimeout = const Duration(minutes: 1).inMilliseconds;
    dio.options.receiveTimeout = const Duration(minutes: 1).inMilliseconds;

    dio.interceptors.addAll([
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: true,
      ),
    ]);
  }

  /// EVENT
  Future<Object> _handleResponse(Response response) async {
    try {
      if (response.statusCode == 401 || response.statusCode == 500) {
        await Helpers.clearToken();
        try {
          AppSnackBar.info(response.data['message']);
        } catch (e) {
          AppSnackBar.info(response.data['error']);
        }
      }
      return response;
    } catch (error) {
      print('$error');
      return response;
    }
  }

  void _getMessage(String? type) {
    switch (type) {
      case 'no_internet':
        AppSnackBar.dynamic(
            seconds: 4,
            backgroundColor: Colors.black54,
            title: 'No Internet Connection',
            icon: Icon(Icons.wifi_tethering_off, color: Colors.white),
            message: 'Please check your network connection');

        break;
      case 'timeout':
        AppSnackBar.dynamic(
            seconds: 4,
            backgroundColor: Colors.black54,
            title: 'Connection Timeout!',
            icon: Icon(Icons.alarm_off, color: Colors.white),
            message: 'Please check your network connection');
        break;
      case 'error':
        AppSnackBar.dynamic(
            seconds: 4,
            backgroundColor: Colors.black54,
            title: 'Connection Error!',
            icon: Icon(Icons.running_with_errors_sharp, color: Colors.white),
            message: 'Request failed');
        break;
    }
  }

  ///

  Future post(String path, dynamic data, {query, options}) async {
    if (await ConnectionUtils.isNetworkConnected()) {
      try {
        final response = await dio.post(path,
            data: data,
            options: options ??
                Options(contentType: Headers.formUrlEncodedContentType));
        return _handleResponse(response);
      } on BadNetworkApiError {
        throw BadNetworkException();
      } on InternalServerApiError {
        throw InternalServerException();
      } on UnauthorizedApiError catch (e) {
        throw UnauthenticatedException(errorMessage: e.message);
      } on ApiErrorMessageError catch (e) {
        throw ApiErrorMessageException(errorMessage: e.errorMessage);
      } on DioError catch (e) {
        if (e.type == DioErrorType.response) {
          return _handleResponse(e.response!);
        } else if (e.type == DioErrorType.connectTimeout) {
          _getMessage('timeout');
        } else if (e.type == DioErrorType.receiveTimeout) {
          _getMessage('timeout');
        } else if (e.type == DioErrorType.sendTimeout) {
          _getMessage('timeout');
        } else if (e.type == DioErrorType.other) {
          _getMessage('error');
        }
      }
    } else {
      _getMessage('no_internet');
      throw BadNetworkException();
    }
  }

  Future put(String path, dynamic data, {query}) async {
    if (await ConnectionUtils.isNetworkConnected()) {
      try {
        final response =
            await dio.put(path, data: data, queryParameters: query);
        return _handleResponse(response);
      } on BadNetworkApiError {
        throw BadNetworkException();
      } on InternalServerApiError {
        throw InternalServerException();
      } on UnauthorizedApiError catch (e) {
        throw UnauthenticatedException(errorMessage: e.message);
      } on ApiErrorMessageError catch (e) {
        throw ApiErrorMessageException(errorMessage: e.errorMessage);
      } on DioError catch (e) {
        if (e.type == DioErrorType.response) {
          return _handleResponse(e.response!);
        } else if (e.type == DioErrorType.connectTimeout) {
          _getMessage('timeout');
        } else if (e.type == DioErrorType.receiveTimeout) {
          _getMessage('timeout');
        } else if (e.type == DioErrorType.sendTimeout) {
          _getMessage('timeout');
        } else if (e.type == DioErrorType.other) {
          _getMessage('error');
        }
      }
    } else {
      _getMessage('no_internet');
      throw BadNetworkException();
    }
  }

  Future delete(String path, {query}) async {
    if (await ConnectionUtils.isNetworkConnected()) {
      try {
        final response = await dio.delete(path, queryParameters: query);
        return _handleResponse(response);
      } on BadNetworkApiError {
        throw BadNetworkException();
      } on InternalServerApiError {
        throw InternalServerException();
      } on UnauthorizedApiError catch (e) {
        throw UnauthenticatedException(errorMessage: e.message);
      } on ApiErrorMessageError catch (e) {
        throw ApiErrorMessageException(errorMessage: e.errorMessage);
      } on DioError catch (e) {
        if (e.type == DioErrorType.response) {
          return _handleResponse(e.response!);
        } else if (e.type == DioErrorType.connectTimeout) {
          _getMessage('timeout');
        } else if (e.type == DioErrorType.receiveTimeout) {
          _getMessage('timeout');
        } else if (e.type == DioErrorType.sendTimeout) {
          _getMessage('timeout');
        } else if (e.type == DioErrorType.other) {
          _getMessage('error');
        }
      }
    } else {
      _getMessage('no_internet');
      throw BadNetworkException();
    }
  }

  Future get(String path, {query}) async {
    if (await ConnectionUtils.isNetworkConnected()) {
      try {
        final response = await dio.get(path,
            queryParameters: query,
            options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              },
            ));
        return _handleResponse(response);
      } on BadNetworkApiError {
        throw BadNetworkException();
      } on InternalServerApiError {
        throw InternalServerException();
      } on UnauthorizedApiError catch (e) {
        throw UnauthenticatedException(errorMessage: e.message);
      } on ApiErrorMessageError catch (e) {
        throw ApiErrorMessageException(errorMessage: e.errorMessage);
      } on DioError catch (e) {
        if (e.type == DioErrorType.response) {
          return _handleResponse(e.response!);
        } else if (e.type == DioErrorType.connectTimeout) {
          _getMessage('timeout');
        } else if (e.type == DioErrorType.receiveTimeout) {
          _getMessage('timeout');
        } else if (e.type == DioErrorType.sendTimeout) {
          _getMessage('timeout');
        } else if (e.type == DioErrorType.other) {
          _getMessage('error');
        }
      }
    } else {
      _getMessage('no_internet');
      throw BadNetworkException();
    }
  }
}
