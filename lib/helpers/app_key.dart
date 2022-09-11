import 'package:absen/helpers/utils/prefs_utils.dart';

class AppKey {
  // master location
  static String? getTargetLocation() => Prefs.getString('master_location');
  static Future<bool> setTargetLocation(String value) =>
      Prefs.setString('master_location', value);
  static Future<bool> resetTargetLocation() =>
      Prefs.setString('master_location', 'null');

  // master attendance
  static List<String>? getListAttendance() =>
      Prefs.getStringList('master_attendance');
  static Future<bool> setListAttendance(List<String> value) =>
      Prefs.setStringList('master_attendance', value);
}
