import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

class ChartIndicator extends StatelessWidget {
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
    final Duration gap = Duration(minutes: 282);
    final int startMin = date.hour * 60 + date.minute;
    final int gapMin = gap.inMinutes;
    final int startAngle = (startMin / 2).floor();
    final int gapAngle = (gapMin / 2).floor();
    return [
      CustomPaint(
        painter: ChartClock(
          color: CupertinoColors.white,
          angleGap: gapAngle,
          startAngle: startAngle,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: CustomPaint(
          painter: ChartClock(
            color: Color(0xff25f2ff),
            angleGap: gapAngle,
            startAngle: startAngle,
          ),
        ),
      ),
    ];
  }
}

class ChartClock extends CustomPainter {
  final Color color;
  final int startAngle;
  final int angleGap;

  ChartClock({
    this.color,
    this.startAngle,
    this.angleGap,
  });
  @override
  void paint(Canvas canvas, Size size) {
    Offset center = size.center(Offset(0, 0));
    Rect rect = Rect.fromCircle(
      center: center,
      radius: size.height / 2.0,
    );
    Path path = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(rect, math.pi / (startAngle / 180.0),
          math.pi * (angleGap / 180.0), false);
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(ChartClock oldDelegate) {
    if (color != oldDelegate.color ||
        startAngle != oldDelegate.startAngle ||
        angleGap != oldDelegate.angleGap)
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
