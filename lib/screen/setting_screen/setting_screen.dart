import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_off/bloc/setting_bloc.dart';
import 'package:im_off/model/jobs.dart';
import 'package:im_off/model/times.dart';
import 'package:im_off/model/user_setting.dart';
import 'package:im_off/screen/setting_screen/common.dart';
import 'package:im_off/screen/setting_screen/custom_picker.dart';
import 'package:im_off/screen/setting_screen/notification_switch.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            SettingMain(),
            Positioned(
              bottom: 30.0,
              right: 30.0,
              child: SettingDone(),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingDone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        UserSetting setting =
            BlocProvider.of<SettingBloc>(context).userSettings;
        if (setting.jobNum == null ||
            setting.startMinute == null ||
            setting.endMinute == null) {
          showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text("모든 설정을 완료해 주세요"),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text("확인"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else
          Navigator.of(context).pop();
      },
      child: Container(
        decoration: ShapeDecoration(
          shape: CircleBorder(),
          color: Color(0xff3a2eff),
        ),
        width: 90.0,
        height: 90.0,
        child: Center(
          child: Text(
            "확인",
            style: const TextStyle(
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w700,
              fontFamily: "SpoqaHanSans",
              fontStyle: FontStyle.normal,
              fontSize: 22.0,
            ),
          ),
        ),
      ),
    );
  }
}

class SettingMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SettingBloc _settingBloc = BlocProvider.of<SettingBloc>(context);
    UserSetting _userSetting = _settingBloc.currentState.settings;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 28.0,
        horizontal: 30.0,
      ),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          SizedBox(height: 12.0),
          JalnanTitle(title: '출퇴근 시간을 설정해주세요.', size: 16.0),
          SizedBox(height: 16.0),
          SettingSelector(
            title: '출근 시간',
            itemFields: timeItemList,
            onSelected: (List<Item> result) {
              if (result != null) {
                int time = _timeInMinutes(result);
                _settingBloc.dispatch(
                  SettingEvent(
                    settings: _userSetting.copWith(startMinute: time),
                    action: SettingAction.setSettings,
                  ),
                );
              }
            },
          ),
          SizedBox(height: 6.0),
          SettingSelector(
            title: '퇴근 시간',
            itemFields: timeItemList,
            onSelected: (List<Item> result) {
              if (result != null) {
                int time = _timeInMinutes(result);
                _settingBloc.dispatch(
                  SettingEvent(
                    settings: _userSetting.copWith(endMinute: time),
                    action: SettingAction.setSettings,
                  ),
                );
              }
            },
          ),
          SizedBox(height: 50.0),
          JalnanTitle(title: '직군을 선택해주세요.', size: 16.0),
          SizedBox(height: 16.0),
          SettingSelector(
            title: '나의 직군',
            itemFields: [
              const ItemList(
                items: jobs,
                listTitle: 'jobs',
              ),
            ],
            onSelected: (List<Item> result) {
              if (result != null) {
                _settingBloc.dispatch(
                  SettingEvent(
                    settings: _userSetting.copWith(jobNum: result[0].index),
                    action: SettingAction.setSettings,
                  ),
                );
              }
            },
          ),
          SizedBox(height: 50.0),
          NotificationSwitch(),
          SizedBox(height: 10.0),
          Text(
            "퇴근시간 후 30분 간격의 퇴근확인\n푸시알림이 발생합니다.",
            style: const TextStyle(
              color: const Color(0xff191919),
              fontWeight: FontWeight.w300,
              fontFamily: "SpoqaHanSans",
              fontStyle: FontStyle.normal,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  int _timeInMinutes(List<Item> times) {
    int timeInMinutes = 0;
    if (times[0].value == pmAm[1]) timeInMinutes = 60 * 12;
    if (times[1].value != 12) timeInMinutes += int.parse(times[1].value) * 60;

    timeInMinutes += int.parse(times[2].value);
    return timeInMinutes;
  }
}

class SettingSelector extends StatelessWidget {
  final String title;
  final List<ItemList> itemFields;
  final Function onSelected;

  SettingSelector({
    this.title,
    @required this.itemFields,
    this.onSelected,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
        color: Color(0xfff3f3f3),
      ),
      child: CupertinoButton(
        onPressed: () async {
          var result = await showCupertinoDialog(
            context: context,
            builder: (context) {
              return CustomPicker(
                fields: this.itemFields,
                height: this.itemFields.length == 1 ? 372 : 279,
              );
            },
          );
          if (this.onSelected != null) {
            this.onSelected(result);
          }
        },
        padding: EdgeInsets.symmetric(
          horizontal: 14.0,
          vertical: 8.0,
        ),
        child: Row(
          children: <Widget>[
            Text(
              this.title,
              style: const TextStyle(
                color: const Color(0xff3c3c3c),
                fontWeight: FontWeight.w400,
                fontFamily: "JalnanOTF",
                fontStyle: FontStyle.normal,
                fontSize: 22.0,
              ),
            ),
            Spacer(),
            Image.asset(
              'images/icon_down.png',
              height: 26,
              width: 26,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
