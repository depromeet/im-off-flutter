class UserSetting {
  final int jobNum;
  final int startMinute;
  final int endMinute;
  final bool isAlarmSet;

  UserSetting({
    this.endMinute,
    this.isAlarmSet,
    this.jobNum,
    this.startMinute,
  });

  UserSetting copWith({
    int jobNum,
    int startMinute,
    int endMinute,
    bool isAlarmSet,
  }) {
    return UserSetting(
      endMinute: endMinute ?? this.endMinute,
      isAlarmSet: isAlarmSet ?? this.isAlarmSet,
      jobNum: jobNum ?? this.jobNum,
      startMinute: startMinute ?? this.startMinute,
    );
  }

  UserSetting.fromJson(Map<String, dynamic> json)
      : jobNum = json['job'],
        startMinute = json['start'],
        endMinute = json['end'],
        isAlarmSet = json['alarm'];

  Map<String, dynamic> toJson() => {
        'job': this.jobNum,
        'start': this.startMinute,
        'end': this.endMinute,
        'alarm': this.isAlarmSet,
      };
}
