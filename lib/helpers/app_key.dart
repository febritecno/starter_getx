import 'package:absen/helpers/utils/prefs_utils.dart';

class AuthPrefs {
  //remove key
  static Future<dynamic> clearAll() => Prefs.clear();
  static Future<dynamic> removeKey(String key) => Prefs.remove(key);

  // token_key value
  static String? getToken() => Prefs.getString('token_key');
  static Future<bool> setToken(String value) =>
      Prefs.setString('token_key', value);
  static bool isTokenNull() =>
      (Prefs.getString('token_key') == null) ? true : false;
  static Future<bool> resetToken() => Prefs.setString('token_key', 'null');
}
