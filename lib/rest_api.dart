abstract class Rest {
  final String serverAddress;
  final Duration timeoutDuration;

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  };

  Rest(this.serverAddress, this.timeoutDuration);

  Future request(
    String endpoint,
    HttpRequestType requestType, {
    Map<String, dynamic>? body,
    Map<String, String> headers = defaultHeaders,
    bool sendToken = false,
    TokenType tokenType = TokenType.access,
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
