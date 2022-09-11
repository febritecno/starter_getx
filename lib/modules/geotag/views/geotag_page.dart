import 'package:absen/helpers/system/dialog.dart';
import 'package:absen/modules/geotag/controllers/geotag_controller.dart';
import 'package:absen/shared/theme.dart';
import 'package:absen/shared/widgets/components/submit_button.dart';
import 'package:absen/shared/widgets/loading_app.dart';
import 'package:absen/shared/widgets/text_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sizer/sizer.dart';

class GeotagPage extends GetView<GeotagController> {
  const GeotagPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingApp(
        isLoading: controller.isLoading.value,
        backroundColor: Colors.black,
        child: SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    center: LatLng(controller.coord[0], controller.coord[1]),
                    zoom: controller.zoom.toDouble(),
                    onPositionChanged: (position, hasGesture) =>
                        controller.pinMarker(position),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://mt.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                      userAgentPackageName: 'com.example.absen',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          height: 50.w,
                          width: 50.w,
                          point:
                              LatLng(controller.coord[0], controller.coord[1]),
                          builder: (context) => Icon(
                            Icons.location_on,
                            color: kBlueColor,
                            size: 60.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 12.h,
                      alignment: Alignment.center,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black45,
                      ),
                      child: TextApp(
                        "Geser peta untuk memindahkan penanda, lalu tekan simpan (master location)",
                        color: Colors.white,
                        fontSize: 18.sp,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        padding: EdgeInsets.symmetric(
                            horizontal: defaultMargin.w, vertical: 2.h),
                      ),
                    ),
                    SubmitButton(
                      "SIMPAN",
                      color: kGreenColor,
                      onTap: () {
                        AppDialog.showAlert(
                          btnLeft: "Tidak",
                          btnRight: "Iya",
                          desc: "untuk menyimpan master location",
                          onBtnRight: () {
                            Get.back();
                            controller.saveMasterLocation();
                          },
                          title: "Apakah anda yakin ?",
                        );
                      },
                      backroundColor: Colors.transparent,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
