import 'dart:math';

class L {
  static og(data, {x = ''}) {
    return print("$data => L.og$x");
  }
}

class Log {
  // Sample of abstract logging function
  static void info(String text, {bool isError = false}) {
    print('** $text [$isError]');
  }

  static void show(String message, {String? title}) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final genRandom =
        List.generate(10, (index) => _chars[r.nextInt(_chars.length)]).join();
    print('** ${title ?? genRandom} : $message');
  }
}
