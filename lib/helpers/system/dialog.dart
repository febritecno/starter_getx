import 'package:myapp/shared/theme.dart';
import 'package:myapp/helpers/third_party/sizer/sizer.dart';
import 'package:myapp/shared/widgets/components/img_network.dart';
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


// Components
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
          boundaryMargin: const EdgeInsets.all(100),
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
          //* cap dialog height (100.hp = full screen); 80.hp = 80% of screen
          maxHeight: 80.hp,
        ),
        child: Container(
          decoration: const BoxDecoration(
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
                        Text(
                          title!,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                          style: kTitle.copyWith(
                              color: kBlueColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 16.spp),
                        ),
                        SizedBox(height: 2.hp),
                        Text(
                          desc!,
                          textAlign: TextAlign.center,
                          // cap the number of lines shown
                          maxLines: 18,
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          style: kBody.copyWith(fontSize: 14.spp),
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
                                    const EdgeInsets.symmetric(
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
                                child: Text(
                                  btnLeft!,
                                  style: kButton.copyWith(
                                      fontSize: 12.spp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                              )),
                          // gap between the two buttons so they don't touch on short labels
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
                                  const EdgeInsets.symmetric(
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
                              child: Text(
                                btnRight!,
                                style: kButton.copyWith(
                                    fontSize: 12.spp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
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
