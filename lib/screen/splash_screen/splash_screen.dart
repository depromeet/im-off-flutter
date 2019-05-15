import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:lottie_flutter/lottie_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  LottieComposition _composition;
  AnimationController _controller;
  double lottieWidth;
  double lottieHeight;

  @override
  void initState() {
    super.initState();
    _loadLottie();
    _controller = AnimationController(
      vsync: this,
    );
//    _controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    if (this._composition != null) {
      print("duration ${this._composition.duration}");
    }
    return CupertinoPageScaffold(
      child: Container(
        color: CupertinoColors.white,
        child: Center(
          child: this._composition == null
              ? CupertinoActivityIndicator()
              : Lottie(
                  composition: this._composition,
                  coerceDuration: true,
                  size: Size(
                    this._composition.bounds.width / 3,
                    this._composition.bounds.height / 3,
                  ),
                ),
        ),
      ),
    );
  }

  _loadLottie() async {
    String lottieJson = await rootBundle.loadString('assets/splash.json');
    Map lottieData = json.decode(lottieJson);
    LottieComposition comp = LottieComposition.fromMap(lottieData);
    setState(() {
      this._composition = comp;
    });
  }
}
