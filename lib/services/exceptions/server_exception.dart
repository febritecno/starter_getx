class ServerException implements Exception {
  final String? error;
  final StackTrace stacktrace;

  ServerException(this.error, this.stacktrace);

  @override
  String toString() {
    if (error == null) return "ServerException";
    return 'ServerException occured: $error stackTrace: $stacktrace';
  }
}
