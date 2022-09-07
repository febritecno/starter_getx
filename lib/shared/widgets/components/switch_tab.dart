import 'package:absen/helpers/third_party/sizer/sizer.dart';
import 'package:absen/shared/theme.dart';
import 'package:absen/shared/widgets/text_app.dart';
import 'package:flutter/material.dart';

class SwichTab extends StatefulWidget {
  SwichTab({
    Key? key,
    required this.data,
    this.onTap,
    this.isSelected = const [true, false],
    this.width,
  }) : super(key: key);

  final List data;
  final List<bool>? isSelected;
  final Function? onTap;
  final double? width;
  @override
  State<SwichTab> createState() => _SwichTabState();
}

class _SwichTabState extends State<SwichTab> {
  List<bool> _isSelected = [];
  @override
  Widget build(BuildContext context) {
    _isSelected = List.generate(widget.data.length, (i) => false);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          widget.data.length,
          (index) => InkWell(
            onTap: () {
              setState(() {
                _isSelected[index] = true;
              });
              widget.onTap!(index, _isSelected);
            },
            child: Container(
              width: widget.width ?? 42.w,
              height: 4.2.h,
              decoration: BoxDecoration(
                color: widget.isSelected![index] != true
                    ? Colors.grey
                    : kBlueColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: TextApp(widget.data[index],
                    textAlign: TextAlign.center,
                    fontSize: 14.sp,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
