class ResponseInfo {
  String? message;
  int? statusCode;

  ResponseInfo({
    this.message,
    this.statusCode,
  }) {
    message = message ?? 'Unexpected error';
    statusCode = statusCode ?? -1;
  }
}
