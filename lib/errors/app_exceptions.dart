class AppException implements Exception {
  final String _message;

  AppException(this._message) : super();

  @override
  String toString() => _message;
}

class FetchDataException extends AppException {
  FetchDataException(int statusCode) : super('');
}

class InternetConnectionException extends AppException {
  InternetConnectionException() : super('No Internet connection');
}

class WeakInternetConnection extends AppException {
  WeakInternetConnection() : super('Weak internet connection');
}

class NotFoundException extends AppException {
  NotFoundException() : super('Not found');
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException() : super('Unautherized');
}

class BadRequestException extends AppException {
  BadRequestException() : super('Bad Request');
}
