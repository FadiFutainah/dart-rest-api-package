import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rest_api/models/response_entity.dart';
import 'package:rest_api/models/response_info.dart';
import 'package:rest_api/rest_api.dart';
import 'package:rest_api/extension/request_option.dart';

import 'data/token.dart';

class RestApiService extends Rest {
  Dio? _dio;

  RestApiService(
    String serverAddress, {
    TokenType tokenType = TokenType.access,
    Duration timeoutDuration = const Duration(seconds: 80),
    Map<String, String>? requestHeaders,
  }) : super(serverAddress, timeoutDuration, tokenType, requestHeaders) {
    _dio = Dio(BaseOptions(baseUrl: serverAddress));
  }

  @override
  Future<ResponseEntity> request(
    String endpoint,
    HttpRequestType requestType, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool sendToken = false,
    bool encode = true,
    bool decode = true,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      RequestOptions requestOptions = RequestOptions(
        path: endpoint,
        queryParameters: queryParameters,
        data: encode ? jsonEncode(body) : body,
        headers: headers ?? requestHeaders,
      );
      if (sendToken) {
        String token = await Token().accessToken ?? '';

        requestOptions.headers[HttpHeaders.authorizationHeader] =
            '${tokenType.name} $token';
      }
      Response? response = await _getResponse(requestType, requestOptions);
      dynamic data = _returnResponse(response!, decode);
      ResponseInfo responseInfo = ResponseInfo(
        statusCode: response.statusCode,
        message: response.statusMessage,
      );
      return ResponseEntity.complete(data: data, responseInfo: responseInfo);
    } catch (e) {
      ResponseInfo info = _getResponseInfo(e);
      return ResponseEntity.withError(responseInfo: info);
    }
  }

  Future<Response?> _getResponse(
      HttpRequestType type, RequestOptions options) async {
    Response? response;
    print(options.headers[HttpHeaders.authorizationHeader]);
    switch (type) {
      case HttpRequestType.GET:
        response = await _dio!.get(
          options.path,
          options: Options(headers: options.headers),
          queryParameters: options.queryParameters,
        );
        break;
      case HttpRequestType.POST:
        response = await _dio!.post(
          options.path,
          options: Options(headers: options.headers),
          data: options.data,
          queryParameters: options.queryParameters,
        );
        break;
      case HttpRequestType.DELETE:
        response = await _dio!.delete(
          options.path,
          options: Options(headers: options.headers),
          queryParameters: options.queryParameters,
        );
        break;
      case HttpRequestType.PUT:
        response = await _dio!.put(
          options.path,
          options: Options(headers: options.headers),
          queryParameters: options.queryParameters,
          data: options.data,
        );
        break;
      case HttpRequestType.PATCH:
        response = await _dio!.patch(
          options.path,
          options: Options(headers: options.headers),
          queryParameters: options.queryParameters,
          data: options.data,
        );
        break;
      case HttpRequestType.HEAD:
        response = await _dio!.head(
          options.path,
          options: Options(headers: options.headers),
          queryParameters: options.queryParameters,
        );
        break;
      default:
    }

    return response;
  }

  dynamic _returnResponse(Response response, bool decode) {
    if (decode) {
      return jsonDecode(response.data);
    }
    return response.data;
  }

  ResponseInfo _getResponseInfo(Object e) {
    String? message;
    int? statusCode;
    if (e is DioError) {
      message = e.message;
      if (e.response != null) {
        statusCode = e.response!.statusCode;
      }
    }
    return ResponseInfo(statusCode: statusCode, message: message);
  }
}
