import 'package:easy_stateful_builder/easy_stateful_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:im_off/bloc/setting_bloc.dart';
import 'package:im_off/model/jobs.dart';
import 'package:im_off/model/times.dart';
import 'package:im_off/model/user_setting.dart';
import 'package:im_off/model/working_status.dart';
import 'package:im_off/screen/setting_screen/common.dart';
import 'package:im_off/screen/setting_screen/custom_picker.dart';
import 'package:im_off/screen/setting_screen/notification_switch.dart';
import 'package:im_off/service/off_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/constant.dart';

int stringTimeToMinutes(List<Item> times) {
  int timeInMinutes = 0;
  if (times[0].value == pmAm[1]) timeInMinutes = 60 * 12;
  if (times[1].value != 12.toString())
    timeInMinutes += int.parse(times[1].value) * 60;

  timeInMinutes += int.parse(times[2].value);
  return timeInMinutes;
}

String minutesToString(int timeInMinutes, {bool toText = false}) {
  if (timeInMinutes == null) return null;
  String amPm = timeInMinutes >= 720 ? "오후" : "오전";
  int hours = ((timeInMinutes % 720) ~/ 60);
  if (hours == 0) hours = 12;

  int minutes = (timeInMinutes % 60);
  String sHours = hours < 10 ? "0$hours" : "$hours";
  String sMinutes = minutes < 10 ? "0$minutes" : "$minutes";

  if (toText) {
    return "$amPm $sHours시 $sMinutes분";
  }

  return "$amPm $sHours:$sMinutes";
}

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
      onTap: () async {
        UserSetting setting =
            BlocProvider.of<SettingBloc>(context).currentState.settings;
        if (setting?.jobNum == null ||
            setting?.startMinute == null ||
            setting?.endMinute == null) {
          // TODO: 시작 시간 - 끝 시간이 오후 - 오전 인 경우 고려가 필요함.
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
        } else {
          final bool isAppLoded =
              ModalRoute.of(context).settings.arguments as bool;
          if (isAppLoded) {
            // 유저 출퇴근 state가 변경 되어야 함.
            // TODO: 퇴근 시간만 변경 해야함 - 이미 출근 햇으면 출근이니까
            EasyStatefulBuilder.setState(workingStatusKey, (state) {
              WorkingStatus working = state.currentState;
              // if (working.startEpoch != null) {
              //   // 시작 시간을 변경해야 한다.
              //   DateTime started =
              //       DateTime.fromMillisecondsSinceEpoch(working.startEpoch);

              //   int startedMinute = started.hour * 60 + started.minute;
              //   int gap = startedMinute - setting.startMinute;

              //   started = started.subtract(Duration(minutes: gap));
              //   // if (started.millisecondsSinceEpoch >
              //   //         DateTime.now().millisecondsSinceEpoch &&
              //   //     working.endEpoch == null) {
              //   //   // 아직 출근할 시간이 아니다.
              //   //   started = null;
              //   // }
              //   state.nextState = working.copyWith(
              //     endEpoch: working.endEpoch,
              //     setting: setting,
              //   )..saveStatus();
              // } else {
              state.nextState = working.copyWith(
                setting: setting,
              )..saveStatus();
              // }
            });
          }
          if (setting.isAlarmSet ?? false) {
            Time notiTime =
                Time(setting.endMinute ~/ 60, setting.endMinute % 60);
            registerDailyNotification(notiTime);
            // registerPeriodicNotification(notiTime, 30);
          } else {
            cancleAllNotifications();
          }
          Navigator.of(context).pop();
        }
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

    return BlocBuilder(
      bloc: _settingBloc,
      condition: (_old, _new) => true,
      builder: (context, SettingData data) {
        UserSetting _userSetting = data.settings;
        int jobNum = _userSetting?.jobNum;
        int startMinutes = _userSetting?.startMinute;
        int endMinutes = _userSetting?.endMinute;

        String startMinuteInString = minutesToString(startMinutes);
        String endMinuteInString = minutesToString(endMinutes);

        List<String> splitStart = startMinuteInString
            ?.replaceAll(RegExp(':'), ' ')
            ?.split(RegExp(' '));
        List<String> splitEnd =
            endMinuteInString?.replaceAll(RegExp(':'), ' ')?.split(RegExp(' '));

        List<ItemList> timeItemList = [
          ItemList(
            items: pmAm,
            listTitle: '오전 오후',
          ),
          ItemList(
            items: hours,
            listTitle: '시간',
          ),
          ItemList(
            items: minutes,
            listTitle: '분',
          ),
        ];

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
                title: startMinuteInString ?? "출근 시간",
                itemFields: startMinuteInString == null
                    ? timeItemList
                    : timeItemList
                        .asMap()
                        .map(
                          (index, item) => MapEntry(
                                index,
                                item.copy()
                                  ..initialItemIndex = item.items.indexWhere(
                                    (value) => value == splitStart[index],
                                  ),
                              ),
                        )
                        .values
                        .toList(),
                onSelected: (List<Item> result) {
                  if (result != null) {
                    int time = stringTimeToMinutes(result);
                    _settingBloc.dispatch(
                      SettingEvent(
                        settings: _userSetting.copyWith(startMinute: time),
                        action: SettingAction.setSettings,
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 6.0),
              SettingSelector(
                title: endMinuteInString ?? "퇴근 시간",
                itemFields: endMinuteInString == null
                    ? timeItemList
                    : timeItemList
                        .asMap()
                        .map(
                          (index, item) => MapEntry(
                                index,
                                item.copy()
                                  ..initialItemIndex = item.items.indexWhere(
                                    (value) => value == splitEnd[index],
                                  ),
                              ),
                        )
                        .values
                        .toList(),
                onSelected: (List<Item> result) {
                  if (result != null) {
                    int time = stringTimeToMinutes(result);
                    _settingBloc.dispatch(
                      SettingEvent(
                        settings: _userSetting.copyWith(endMinute: time),
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
                title: jobNum == null ? '나의 직군' : jobs[jobNum].toString(),
                itemFields: [
                  ItemList(
                    items: jobs,
                    listTitle: 'jobs',
                    initialItemIndex: jobNum ?? 0,
                  ),
                ],
                onSelected: (List<Item> result) {
                  if (result != null) {
                    _settingBloc.dispatch(
                      SettingEvent(
                        settings:
                            _userSetting.copyWith(jobNum: result[0].index),
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
      },
    );
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
          if (this.onSelected != null && result != null) {
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
