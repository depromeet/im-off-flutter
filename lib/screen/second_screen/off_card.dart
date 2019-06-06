import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:im_off/screen/first_screen/chart_indicator.dart';

class OffCard extends StatelessWidget {
  OffCard({
    this.title = "이번주 근무 시간",
    this.statistic = "34시간",
    this.criteria = "/52시간",
    this.gapMinute,
    this.startMinute,
    this.chartTitle,
    this.chartColor = const Color(0xffff295b),
  });

  String title;
  String statistic;
  String criteria;
  int startMinute;
  int gapMinute;
  String chartTitle;
  Color chartColor;

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
        padding: EdgeInsets.fromLTRB(20.0, 24.0, 24.0, 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  this.title,
                  style: const TextStyle(
                    color: const Color(0xde191919),
                    fontWeight: FontWeight.w300,
                    fontFamily: "SpoqaHanSans",
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0,
                  ),
                ),
                RichText(
                  text: new TextSpan(
                    children: [
                      new TextSpan(
                        style: const TextStyle(
                          color: const Color(0xde191919),
                          fontWeight: FontWeight.w400,
                          fontFamily: "JalnanOTF",
                          fontStyle: FontStyle.normal,
                          fontSize: 24.0,
                        ),
                        text: this.statistic + " ",
                      ),
                      new TextSpan(
                        style: const TextStyle(
                          color: const Color(0xde191919),
                          fontWeight: FontWeight.w400,
                          fontFamily: "JalnanOTF",
                          fontStyle: FontStyle.normal,
                          fontSize: 12.0,
                        ),
                        text: this.criteria ?? " ",
                      ),
                    ],
                  ),
                ),
              ],
            ),
            CustomPaint(
              painter: ChartClock(
                color: this.chartColor,
                startMin: 0,
                gapMin: 100,
              ),
              child: Container(
                width: 64.0,
                height: 64.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
