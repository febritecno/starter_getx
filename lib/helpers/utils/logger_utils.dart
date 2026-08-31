import 'package:flutter/foundation.dart';

class Log {
  // Sample of abstract logging function
  static void info(String text, {bool isError = false}) {
    debugPrint('** $text [$isError]');
  }
}
