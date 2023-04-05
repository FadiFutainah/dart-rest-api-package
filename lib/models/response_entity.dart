import 'package:rest_api/models/response_info.dart';

class ResponseEntity<T> {
  T? data;
  bool _hasError = true;
  ResponseInfo responseInfo;

  bool get hasError => _hasError;

  ResponseEntity.complete({
    required this.data,
    required this.responseInfo,
  }) {
    _hasError = false;
  }

  ResponseEntity.withError({
    required this.responseInfo,
    this.data,
  });
}
