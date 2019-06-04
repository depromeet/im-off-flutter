import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_off/bloc/setting_bloc.dart';
import 'package:im_off/screen/routes.dart';
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
  bool firstLoaded = true;
  double lottieWidth;
  double lottieHeight;

  @override
  void initState() {
    super.initState();
    SettingBloc _settingBloc = BlocProvider.of<SettingBloc>(context);
    _loadLottie();
    _controller = AnimationController(
      vsync: this,
    );
    _controller.addStatusListener(
      (AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _settingBloc
              .dispatch(SettingEvent(action: SettingAction.getSettings));
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SettingBloc _settingBloc = BlocProvider.of<SettingBloc>(context);
    return BlocListener(
      bloc: _settingBloc,
      listener: (context, SettingData data) async {
        switch (data.status) {
          case SettingStatus.isNotInitialized:
            if (firstLoaded) {
              firstLoaded = false;
              await Navigator.of(context)
                  .pushNamed(IamOffRoute.settings, arguments: false);
              return Navigator.of(context).popAndPushNamed(IamOffRoute.home);
            }
            break;
          case SettingStatus.isInitialized:
            if (firstLoaded)
              return Navigator.of(context)
                  .pushReplacementNamed(IamOffRoute.home);
            break;
          default:
            break;
        }
      },
      child: CupertinoPageScaffold(
        child: Container(
          color: CupertinoColors.white,
          child: Center(
            child: this._composition == null
                ? CupertinoActivityIndicator()
                : Lottie(
                    controller: this._controller,
                    composition: this._composition,
                    coerceDuration: true,
                    size: Size(
                      this._composition.bounds.width / 4.5,
                      this._composition.bounds.height / 4.5,
                    ),
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
      this._controller.duration = Duration(milliseconds: comp.duration);
      this._controller.forward();
    });
  }
}
