class ResponseEntity<T> {
  T? data;
  bool _hasError = true;
  String message;

  bool get hasError => _hasError;

  ResponseEntity.complete({
    required this.data,
    this.message = '',
  }) {
    _hasError = false;
  }

  ResponseEntity.withError({
    required this.message,
    this.data,
  });
}
