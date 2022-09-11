import 'dart:convert';

import 'package:absen/helpers/app_key.dart';
import 'package:absen/modules/home/models/home_model.dart';
import 'package:absen/services/exceptions/app_exception.dart';
import 'package:get/get.dart';

class AttendanceController extends GetxController {
  var isLoading = false.obs;
  var attendanceData = <AttendanceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAll();
  }

  getAll() async {
    isLoading(true);
    try {
      final getAttendance = await AppKey.getListAttendance();
      var _data = (getAttendance as List)
          .map((x) => AttendanceModel.fromJson(jsonDecode(x)))
          .toList();
      attendanceData.assignAll(_data);
      isLoading(false);
    } catch (e) {
      isLoading(false);
      throw AppException(message: e.toString());
    }
  }
}
