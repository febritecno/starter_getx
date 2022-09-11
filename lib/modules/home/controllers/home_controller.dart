import 'dart:convert';

import 'package:absen/helpers/app_key.dart';
import 'package:absen/helpers/helpers.dart';
import 'package:absen/helpers/system/snackbar.dart';
import 'package:absen/services/exceptions/app_exception.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var masterAttendance = {"date": "-", "time": "-", "meter": 0}.obs;
  var currentLocation = [0.0, 0.0].obs;
  var targetLocation = ['0.0', '0.0'].obs;

  @override
  void onInit() {
    getTimeNow();
    super.onInit();
  }

  getTimeNow() {
    final now = DateTime.now();
    masterAttendance()['date'] = DateFormat('dd MMM yyyy').format(now);
    masterAttendance()['time'] = DateFormat.jm().format(now);
  }

  distanceInMeter() async {
    final Distance _distance = new Distance();
    targetLocation
        .assignAll(await AppKey.getTargetLocation().toString().split(','));
    await Helpers.determinePosition()
        .then((data) => currentLocation([data.latitude, data.longitude]));
    masterAttendance()['meter'] = await _distance(
      LatLng(double.parse(targetLocation[0]), double.parse(targetLocation[1])),
      LatLng(currentLocation[0], currentLocation[1]),
    ).toInt();
  }

  submitAttendance() async {
    isLoading(true);
    try {
      await getTimeNow();
      await distanceInMeter();
      if ((masterAttendance['meter'] as int) > 50) {
        AppSnackBar.error(
            "Kehadiran ditolak, anda tidak dalam jangkauan 50 meter dari target lokasi",
            title: "Rejected!");
      } else {
        final getAttendance = await AppKey.getListAttendance();
        if (getAttendance == null) {
          AppKey.setListAttendance([jsonEncode(masterAttendance)]);
        } else {
          AppKey.setListAttendance(
              [...getAttendance, jsonEncode(masterAttendance)]);
        }
        print(getAttendance);
        AppSnackBar.success(
          "Kehadiran diterima, anda dalam jangkauan 50 meter dari target lokasi",
          title: "Attendance Approved",
          seconds: 6,
        );
      }
      isLoading(false);
    } catch (e) {
      isLoading(false);
      AppSnackBar.error("Tidak dapat menemukan lokasi ...");
      throw AppException(message: e.toString());
    }
  }
}
