import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_off/bloc/setting_bloc.dart';
import 'package:im_off/model/user_setting.dart';
import 'package:im_off/screen/setting_screen/common.dart';

class NotificationSwitch extends StatefulWidget {
  @override
  _NotificationSwitchState createState() => _NotificationSwitchState();
}

class _NotificationSwitchState extends State<NotificationSwitch> {
  bool isSet;
  final Duration animationDuration = const Duration(
    milliseconds: 200,
  );

  @override
  void initState() {
    super.initState();
    this.isSet = false;
    SettingBloc _settingBloc = BlocProvider.of<SettingBloc>(context);
    UserSetting setting = _settingBloc.userSettings;
    if (setting != null) isSet = setting.isAlarmSet;
  }

  @override
  Widget build(BuildContext context) {
    final double positionLeft = isSet ? 34 : 0;
    final Color barColor = isSet ? Color(0xffe8e7ff) : Color(0xffececec);
    final Color circleColor = isSet ? Color(0xff3a2eff) : Color(0xffc4c4c4);
    SettingBloc _settingBloc = BlocProvider.of<SettingBloc>(context);

    return BlocBuilder(
      bloc: _settingBloc,
      builder: (context, SettingData data) {
        UserSetting setting = data.settings;

        return CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            setState(() {
              this.isSet = !this.isSet;
              _settingBloc.dispatch(
                SettingEvent(
                  action: SettingAction.setSettings,
                  settings: setting.copWith(
                    isAlarmSet: this.isSet,
                  ),
                ),
              );
            });
          },
          pressedOpacity: 1.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              JalnanTitle(title: '칼퇴 확인 알림', size: 18.0),
              SizedBox(width: 16.0),
              Container(
                height: 24.0,
                width: 58.0,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: AnimatedContainer(
                        duration: animationDuration,
                        width: 34.0,
                        height: 14.0,
                        decoration: ShapeDecoration(
                          shape: StadiumBorder(),
                          color: barColor,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: animationDuration,
                      left: positionLeft,
                      child: AnimatedContainer(
                        duration: animationDuration,
                        width: 24.0,
                        height: 24.0,
                        decoration: ShapeDecoration(
                          shape: CircleBorder(),
                          color: circleColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
