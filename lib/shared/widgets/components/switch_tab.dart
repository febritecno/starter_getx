import 'package:myapp/shared/theme.dart';
import 'package:myapp/helpers/third_party/sizer/sizer.dart';
import 'package:flutter/material.dart';

class SwichTab extends StatefulWidget {
  const SwichTab({
    super.key,
    required this.data,
    this.onTap,
    this.isSelected = const [true, false],
    this.width,
  });

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
      padding: EdgeInsets.symmetric(vertical: 2.hp),
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
              width: widget.width ?? 42.wp,
              height: 4.2.hp,
              decoration: BoxDecoration(
                color: widget.isSelected![index] != true
                    ? Colors.grey
                    : kBlueColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(widget.data[index],
                    textAlign: TextAlign.center,
                    style:
                        kBody.copyWith(fontSize: 14.spp, color: Colors.white)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
