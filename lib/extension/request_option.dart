import 'package:dio/dio.dart';
import 'package:rest_api/rest_api_package.dart';

extension AppRequestOptions on RequestOptions {
  Future<void> addTokenHeader(TokenType tokenType) async {
    String token = await Token().accessToken ?? '';
    this.headers['Authorization'] = '${tokenType.name} $token';
  }
}
