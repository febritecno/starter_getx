class AppException implements Exception {
  final String? message, stackTrace, locate;

  AppException(
      {this.stackTrace = 'null',
      this.message = 'null',
      this.locate = 'AppException'});

  @override
  String toString() {
    if (message == null) return "AppException";
    print('[>] $locate');
    print('[x] MESSAGE: $message');
    return "[-] STACKTRACE: $stackTrace";
  }
}
