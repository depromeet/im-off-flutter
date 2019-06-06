import 'package:easy_stateful_builder/easy_stateful_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

import 'package:im_off/bloc/setting_bloc.dart';
import 'package:im_off/model/working_status.dart';
import 'package:im_off/model/constant.dart';

enum WorkingStatusType { rest, working, extraWork, success, failed }

class ChartIndicator extends StatefulWidget {
  ChartIndicator({
    this.status,
  });
  final WorkingStatus status;
  @override
  _ChartIndicatorState createState() => _ChartIndicatorState();
}

class _ChartIndicatorState extends State<ChartIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _chartSize;
  SettingBloc _settingBloc;

  @override
  void initState() {
    super.initState();

    this._settingBloc = BlocProvider.of<SettingBloc>(context);

    this._animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2700),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    this._animationController.addListener(() => setState(() {}));
    _chartSize = CurveTween(
      curve: Curves.easeOutQuart,
    ).animate(this._animationController);
    this._animationController.forward();
  }

  @override
  void dispose() {
    this._animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String outlineAsset = 'images/circle_gradation_red.png';
    Color arcColor;
    WorkingStatus status =
        EasyStatefulBuilder.getState(workingStatusKey).currentState;
    WorkingStatusType workingType;

    if (status?.endEpoch != null) {
      //퇴근 했다.
      int gotOffTime = status.endEpoch;
      DateTime started = DateTime.fromMillisecondsSinceEpoch(status.startEpoch);
      DateTime expected = DateTime(started.year, started.month, started.day,
          status.setting.endMinute ~/ 60, status.setting.endMinute % 60);
      expected = expected.add(Duration(minutes: 15));

      outlineAsset = "images/circle_gradation_blue.png";
      workingType = WorkingStatusType.success;
      arcColor = Color(0xff25f2ff);

      if (gotOffTime >= expected.millisecondsSinceEpoch) {
        // 야근 했다.
        outlineAsset = 'images/circle_gradation_red.png';
        workingType = WorkingStatusType.failed;
        arcColor = Color(0xffff295b);
      }
    } else if (status?.startEpoch != null) {
      // 출근 했다.
      DateTime started = DateTime.fromMillisecondsSinceEpoch(status.startEpoch);
      DateTime expected = DateTime(started.year, started.month, started.day,
          status.setting.endMinute ~/ 60, status.setting.endMinute % 60);
      expected = expected.add(Duration(minutes: 15));
      if (now.millisecondsSinceEpoch > expected.millisecondsSinceEpoch) {
        // 야근 중이다.
        outlineAsset = 'images/circle_gradation_red.png';
        workingType = WorkingStatusType.extraWork;
        arcColor = Color(0xffff295b);
      } else {
        outlineAsset = "images/circle_gradation_blue.png";
        workingType = WorkingStatusType.working;
        arcColor = Color(0xff25f2ff);
      }
    } else {
      // 출근 안했다.
      outlineAsset = "images/circle_gradation_gray.png";
      workingType = WorkingStatusType.rest;
      arcColor = Colors.transparent;
    }
    return SizedBox(
      width: 304.0,
      height: 304.0,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          OutlineAnimator(
            asset: outlineAsset,
          ),
          ..._buildTimeSector(workingType, arcColor),
          Center(
            child: Text(
              "${now.hour}:${now.minute}",
              style: const TextStyle(
                color: const Color(0xff191919),
                fontWeight: FontWeight.w400,
                fontFamily: "JalnanOTF",
                fontStyle: FontStyle.normal,
                fontSize: 65.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTimeSector(WorkingStatusType type, Color arcColor) {
    final DateTime date = DateTime.now();
    final int gapMin = Duration(minutes: 201).inMinutes;
    final int startMin = (date.hour * 60 + date.minute) % 720;
    return [
      if (type != WorkingStatusType.rest)
        CustomPaint(
          painter: ChartClock(
            color: CupertinoColors.white,
            gapMin: gapMin * this._chartSize.value,
            startMin: startMin,
          ),
        ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: CustomPaint(
          painter: ChartClock(
            color: arcColor,
            gapMin: gapMin * this._chartSize.value,
            startMin: startMin,
          ),
        ),
      ),
    ];
  }
}

class ChartClock extends CustomPainter {
  final Color color;
  final int startMin;
  final double gapMin;

  ChartClock({
    this.color,
    this.startMin,
    this.gapMin,
  });
  @override
  void paint(Canvas canvas, Size size) {
    Offset center = size.center(Offset(0, 0));
    double start = 2 * math.pi * ((this.startMin - 180) / 720.0);
    double gap = 2 * math.pi * (this.gapMin / 720.0);

    Rect rect = Rect.fromCircle(
      center: center,
      radius: (size.height + 2) / 2.0,
    );
    canvas.drawArc(rect, start, gap, true, Paint()..color = color);
  }

  @override
  bool shouldRepaint(ChartClock oldDelegate) {
    if (color != oldDelegate.color ||
        startMin != oldDelegate.startMin ||
        gapMin != oldDelegate.gapMin)
      return true;
    else
      return false;
  }
}

class OutlineAnimator extends StatefulWidget {
  OutlineAnimator({
    this.asset,
  });
  final String asset;
  @override
  _OutlineAnimatorState createState() => _OutlineAnimatorState();
}

class _OutlineAnimatorState extends State<OutlineAnimator>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: Image.asset(
        widget.asset,
        fit: BoxFit.contain,
      ),
      builder: (BuildContext context, Widget child) {
        return Transform.rotate(
          angle: _animationController.value * 2.0 * math.pi,
          child: child,
        );
      },
    );
  }
}
