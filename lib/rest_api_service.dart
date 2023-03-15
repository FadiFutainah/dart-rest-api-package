import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rest_api/models/response_entity.dart';
import 'package:rest_api/rest_api.dart';
import 'package:rest_api/extension/request_option.dart';

import 'errors/app_exceptions.dart';

class RestApiService extends Rest {
  Dio? _dio;

  RestApiService(
    String serverAddress, {
    Duration timeoutDuration = const Duration(seconds: 80),
  }) : super(serverAddress, timeoutDuration) {
    _dio = Dio(BaseOptions(baseUrl: serverAddress));
  }

  @override
  Future<ResponseEntity> request(
    String endpoint,
    HttpRequestType requestType, {
    Map<String, dynamic>? body,
    Map<String, String> headers = Rest.defaultHeaders,
    bool sendToken = false,
    bool encode = true,
    bool decode = true,
    TokenType tokenType = TokenType.access,
  }) async {
    try {
      RequestOptions requestOptions = RequestOptions(
        path: endpoint,
        data: encode ? jsonEncode(body) : body,
        headers: headers,
        receiveTimeout: timeoutDuration.inSeconds,
      );
      if (sendToken) {
        requestOptions.addTokenHeader(tokenType);
      }
      dynamic data = await _getResponse(requestType, requestOptions, decode);
      return ResponseEntity.complete(data: data);
    } catch (e) {
      String message = _getExceptionMessage(e);
      return ResponseEntity.withError(message: message);
    }
  }

  dynamic _getResponse(
      HttpRequestType type, RequestOptions options, bool decode) async {
    Response? response;
    switch (type) {
      case HttpRequestType.GET:
        response = await _dio!.get(
          options.path,
          options: Options(headers: options.headers),
        );
        break;
      case HttpRequestType.POST:
        response = await _dio!.post(
          options.path,
          options: Options(headers: options.headers),
          data: options.data,
        );
        break;
      case HttpRequestType.DELETE:
        response = await _dio!.delete(
          options.path,
          options: Options(headers: options.headers),
        );
        break;
      case HttpRequestType.PUT:
        response = await _dio!.put(
          options.path,
          options: Options(headers: options.headers),
          data: options.data,
        );
        break;
      case HttpRequestType.PATCH:
        response = await _dio!.patch(
          options.path,
          options: Options(headers: options.headers),
          data: options.data,
        );
        break;
      case HttpRequestType.HEAD:
        response = await _dio!.head(
          options.path,
          options: Options(headers: options.headers),
        );
        break;
      default:
    }

    return _returnResponse(response!, decode);
  }

  dynamic _returnResponse(Response response, bool decode) {
    if (decode) {
      return jsonDecode(response.data);
    }
    return response.data;
  }

  String _getExceptionMessage(Object e) {
    if (e is SocketException) {
      return InternetConnectionException().toString();
    }
    if (e is DioError) {
      switch (e.type) {
        case DioErrorType.other:
          return InternetConnectionException().toString();
        case DioErrorType.response:
          return _getStatusException(e.response!.statusCode!);
        case DioErrorType.connectTimeout:
          return WeakInternetConnection().toString();
        case DioErrorType.sendTimeout:
          break;
        case DioErrorType.receiveTimeout:
          break;
        case DioErrorType.cancel:
          break;
      }
    }
    return 'Unexpected Error';
  }

  String _getStatusException(int statusCode) {
    Map<int, AppException> excptions = {
      400: BadRequestException(),
      404: NotFoundException(),
      401: UnAuthorizedException(),
    };
    if (excptions[statusCode] == null) {
      return FetchDataException(statusCode).toString();
    }
    return excptions[statusCode].toString();
  }
}
