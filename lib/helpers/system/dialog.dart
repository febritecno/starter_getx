import 'package:myapp/shared/theme.dart';
import 'package:myapp/helpers/third_party/sizer/sizer.dart';
import 'package:myapp/shared/widgets/components/img_network.dart';
import 'package:myapp/shared/widgets/text_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDialog {
  static void load(Widget child,
      {barrierDismissible = false, barrierColor = Colors.black45}) {
    Get.dialog(
      child,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<dynamic> showAlert(
      {required title,
      required btnLeft,
      required btnRight,
      required desc,
      onBtnLeft,
      onBtnRight}) {
    return showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertItem(
              btnLeft: btnLeft,
              btnRight: btnRight,
              desc: desc,
              onBtnLeft: onBtnLeft,
              onBtnRight: onBtnRight,
              title: title);
        });
  }

  static Future<dynamic> previewImage({image}) {
    return showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return PreviewItem(
            image: image,
          );
        });
  }
}

class PreviewItem extends StatelessWidget {
  final String? image;

  const PreviewItem({
    super.key,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => Get.back(),
      child: Container(
        color: Colors.black.withValues(alpha: 0.8),
        child: InteractiveViewer(
          panEnabled: false,
          boundaryMargin: EdgeInsets.all(100),
          minScale: 0.5,
          maxScale: 2,
          child: AlertDialog(
              contentPadding: EdgeInsets.zero,
              titlePadding: EdgeInsets.zero,
              buttonPadding: EdgeInsets.zero,
              actionsPadding: EdgeInsets.zero,
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              content: ImgNetwork(image!)),
        ),
      ),
    );
  }
}

//* AUTOSIZE CONTAINER DIALOG
class AlertItem extends StatelessWidget {
  final String? title, desc, btnLeft, btnRight;
  final Widget? body, footer;
  final VoidCallback? onBtnLeft, onBtnRight;

  const AlertItem({
    super.key,
    this.title,
    this.desc,
    this.btnLeft,
    this.btnRight,
    this.onBtnLeft,
    this.onBtnRight,
    this.body,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: ConstrainedBox(
        constraints: BoxConstraints(
          //* atur maxHeight buat batasin ukuran dialog 100.hp = 100% full screen di layar
          maxHeight: 80.hp,
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color(0x00ffffff),
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              body == null
                  ? Column(
                      children: [
                        TextApp(
                          title!,
                          color: kBlueColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 16.spp,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                        ),
                        SizedBox(height: 2.hp),
                        TextApp(
                          desc!,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.spp,
                          textAlign: TextAlign.center,
                          // *atur maxLines buat batasin max baris yang ditampilkan
                          maxLines: 18,
                          softWrap: true,
                          overflow: TextOverflow.clip,
                        ),
                      ],
                    )
                  : body!,
              footer == null
                  ? Padding(
                      padding: EdgeInsets.only(top: 4.hp),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    return kBlueColor;
                                  },
                                ),
                                padding: WidgetStateProperty.all(
                                    EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 0)),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minimumSize:
                                    WidgetStateProperty.all(Size(30.wp, 20)),
                                shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                )),
                              ),
                              onPressed:
                                  onBtnLeft ?? () => Navigator.pop(context),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 1.wp, vertical: 1.5.hp),
                                child: TextApp(
                                  btnLeft!,
                                  fontSize: 12.spp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              )),
                          // *atur jarak kedua tombol agar engga gancet ketika text cuma sebiji
                          SizedBox(width: 3.wp),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  return kBlueColor;
                                },
                              ),
                              padding: WidgetStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 0)),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize:
                                  WidgetStateProperty.all(Size(30.wp, 20)),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              )),
                            ),
                            onPressed: onBtnRight,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 1.wp, vertical: 1.5.hp),
                              child: TextApp(
                                btnRight!,
                                fontSize: 12.spp,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : footer!
            ],
          ),
        ),
      ),
    );
  }
}
//*
