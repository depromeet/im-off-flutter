import 'dart:convert';

import 'package:im_off/model/constant.dart';
import 'package:im_off/model/user_setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkingStatus {
  int startEpoch;
  int endEpoch;
  bool isWeekDay;
  UserSetting setting;

  WorkingStatus({
    this.isWeekDay = true,
    this.setting,
    this.startEpoch,
    this.endEpoch,
  });

  WorkingStatus copyWith({
    bool isWeekDay,
    bool initialized,
    UserSetting setting,
    int startEpoch,
    int endEpoch,
  }) =>
      WorkingStatus(
        isWeekDay: isWeekDay ?? this.isWeekDay,
        setting: setting ?? this.setting,
        startEpoch: startEpoch ?? this.startEpoch,
        endEpoch: endEpoch ?? this.endEpoch,
      );

  WorkingStatus.fromJson(Map<String, dynamic> json)
      : isWeekDay = true,
        startEpoch = json['startEpoch'],
        endEpoch = json['endEpoch'];

  Map<String, dynamic> toJson() => {
        'startEpoch': this.startEpoch,
        'endEpoch': this.endEpoch,
      };

  void saveStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(workingStatusKey, jsonEncode(this));
  }
}
