import 'package:im_off/model/user_setting.dart';

class WorkingStatus {
  int startTimeInMinute;
  int endTimeInMinute;
  bool isWeekDay;
  bool gotOff;
  bool initialized;
  UserSetting setting;

  WorkingStatus({
    this.endTimeInMinute,
    this.startTimeInMinute,
    this.isWeekDay = true,
    this.gotOff = false,
    this.setting,
    this.initialized = false,
  });

  WorkingStatus copyWith({
    int startTimeInMinute,
    int endTimeInMinute,
    bool isWeekDay,
    bool gotOff,
    bool initialized,
    UserSetting setting,
  }) =>
      WorkingStatus(
        endTimeInMinute: endTimeInMinute ?? this.endTimeInMinute,
        startTimeInMinute: startTimeInMinute ?? this.startTimeInMinute,
        isWeekDay: isWeekDay ?? this.isWeekDay,
        gotOff: gotOff ?? this.gotOff,
        setting: setting ?? this.setting,
        initialized: initialized ?? this.initialized,
      );

  WorkingStatus.fromJson(Map<String, dynamic> json)
      : startTimeInMinute = json['start'],
        gotOff = json['off'],
        isWeekDay = true,
        initialized = json['init'],
        endTimeInMinute = json['end'];

  Map<String, dynamic> toJson() => {
        'start': this.startTimeInMinute,
        'end': this.endTimeInMinute,
        'off': this.gotOff,
        'init': this.initialized,
      };
}
