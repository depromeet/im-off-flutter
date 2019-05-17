import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_off/bloc/setting_bloc.dart';
import 'package:im_off/model/user_setting.dart';
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
      listener: (context, SettingData data) {
        UserSetting setting = data.settings;
        switch (data.status) {
          case SettingStatus.isNotInitialized:
            return Navigator.of(context).pushNamed(IamOffRoute.settings);
          case SettingStatus.isInitialized:
            return Navigator.of(context).pushReplacementNamed(IamOffRoute.home);
          default:
            // TODO: settings의 데이터 중에 null인 데이터 있는지 확인해야함.
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
                      this._composition.bounds.width / 3,
                      this._composition.bounds.height / 3,
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
