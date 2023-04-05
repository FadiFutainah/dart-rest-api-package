abstract class Rest {
  final String serverAddress;
  final Duration timeoutDuration;
  final TokenType tokenType;
  final Map<String, String>? requestHeaders;

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  };

  Rest(
    this.serverAddress,
    this.timeoutDuration,
    this.tokenType, [
    this.requestHeaders = defaultHeaders,
  ]);

  Future request(
    String endpoint,
    HttpRequestType requestType, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool sendToken = false,
  });
}

enum TokenType {
  JWT,
  access,
  refresh,
  Bearer,
}

enum HttpRequestType {
  GET,
  POST,
  DELETE,
  PUT,
  PATCH,
  HEAD,
}
