import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

import 'package:im_off/bloc/setting_bloc.dart';

class ChartIndicator extends StatefulWidget {
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
      duration: Duration(milliseconds: 1000),
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
    return SizedBox(
      width: 294.0,
      height: 294.0,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          OutlineAnimator(),
          ..._buildTimeSector(),
        ],
      ),
    );
  }

  List<Widget> _buildTimeSector() {
    final DateTime date = DateTime.now();
    final int gapMin = Duration(minutes: 682).inMinutes;
    final int startMin = (date.hour * 60 + date.minute) % 720;
    return [
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
            color: Color(0xff25f2ff),
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
      radius: size.height / 2.0,
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
        'images/circle_gradation_blue.png',
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
