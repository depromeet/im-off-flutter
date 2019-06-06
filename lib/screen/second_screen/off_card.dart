import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class OffCard extends StatelessWidget {
  OffCard({
    this.chartTitle,
    this.desc,
    this.gapMinute,
    this.startMinute,
    this.title,
  });

  String title;
  String desc;
  int startMinute;
  int gapMinute;
  String chartTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ).copyWith(bottom: 12.0),
      child: Container(
        width: double.infinity,
        height: 112.0,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          color: CupertinoColors.white,
          shadows: [
            BoxShadow(
              color: Color(0x809f9f9f),
              blurRadius: 2.0,
              offset: Offset(1.0, 1.0),
            ),
          ],
        ),
        child: Center(child: Text("Hi")),
      ),
    );
  }
}
