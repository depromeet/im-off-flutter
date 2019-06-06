import 'dart:convert';

import 'package:im_off/model/constant.dart';
import 'package:im_off/model/user_setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

String statisticKey = "workingStatistics";

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
        startEpoch: startEpoch,
        endEpoch: endEpoch,
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

  void finish() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(statisticKey) ?? [];
    history.add(startEpoch.toString());
    prefs.setString(startEpoch.toString(), jsonEncode(this)); // 오늘 한 일 저장
    prefs.setStringList(statisticKey, history); // 오늘 한 일의 key 값 저장
  }

  static Future<WorkingHistory> getHistory() async {
    List<WorkingStatus> history = List<WorkingStatus>();

    await for (WorkingStatus status in _getWorkHistory()) {
      history.add(status);
    }

    return WorkingHistory(
      workingHoursAWeek: await _getWorkedHours(history),
      avgOffTimeInMinute: await _getAvgEndMinutes(history),
      extraWorkingWeekday: await _getExtraWorkingWeekday(history),
      fastOffWeekday: await _getFastOffWeekday(history),
    );
  }
}

Stream<WorkingStatus> _getWorkHistory() async* {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> history = prefs.getStringList(statisticKey) ?? [];
  history.sort((String a, String b) {
    int ia = int.parse(a);
    int ib = int.parse(b);
    return ib - ia;
  });

  for (String key in history) {
    String jsonStatus = prefs.getString(key);
    if (jsonStatus != null) {
      WorkingStatus status = WorkingStatus.fromJson(jsonDecode(jsonStatus));
      yield status;
    }
  }
}

class WorkingHistory {
  int workingHoursAWeek;
  int avgOffTimeInMinute;
  String fastOffWeekday;
  String extraWorkingWeekday;

  WorkingHistory({
    this.avgOffTimeInMinute,
    this.extraWorkingWeekday,
    this.fastOffWeekday,
    this.workingHoursAWeek,
  });
}

Future<int> _getWorkedHours(List<WorkingStatus> history) async {
  DateTime now = DateTime.now();
  int minutes = 0;
  for (WorkingStatus status in history) {
    DateTime start = DateTime.fromMillisecondsSinceEpoch(status.startEpoch);
    if (now.weekday >= start.weekday) {
      DateTime end = DateTime.fromMillisecondsSinceEpoch(status.endEpoch);
      Duration gap = end.difference(start);
      minutes += gap.inMinutes;
    } else {
      break;
    }
  }

  return minutes ~/ 60;
}

Future<int> _getAvgEndMinutes(List<WorkingStatus> history) async {
  if (history.isEmpty) return 0;
  int totalMinutes = 0;
  for (WorkingStatus status in history) {
    DateTime end = DateTime.fromMillisecondsSinceEpoch(status.endEpoch);
    totalMinutes += (end.hour * 60 + end.minute);
  }
  int avgMinute = totalMinutes ~/ history.length;
  return avgMinute;
}

Future<String> _getFastOffWeekday(List<WorkingStatus> history) async {
  List<int> totalMinutes = List.generate(10, (i) => 0);
  List<int> workCount = List.generate(10, (i) => 0);
  List<String> weekday = [
    "기록 없음",
    "월요일",
    "화요일",
    "수요일",
    "목요일",
    "금요일",
    "토요일",
    "일요일",
  ];

  for (WorkingStatus status in history) {
    DateTime start = DateTime.fromMillisecondsSinceEpoch(status.startEpoch);
    DateTime end = DateTime.fromMillisecondsSinceEpoch(status.endEpoch);
    Duration gap = end.difference(start);

    totalMinutes[start.weekday] += gap.inMinutes;
    workCount[start.weekday]++;
  }
  int minTime = 0x7fffffff;
  int minWeek = 0;

  for (int i = 0; i < 10; i++) {
    if (workCount[i] != 0) {
      if (minTime > totalMinutes[i] ~/ workCount[i]) {
        minTime = totalMinutes[i] ~/ workCount[i];
        minWeek = i;
      }
    }
  }
  return weekday[minWeek];
}

Future<String> _getExtraWorkingWeekday(List<WorkingStatus> history) async {
  List<int> totalMinutes = List.generate(10, (i) => 0);
  List<int> workCount = List.generate(10, (i) => 0);
  List<String> weekday = [
    "기록 없음",
    "월요일",
    "화요일",
    "수요일",
    "목요일",
    "금요일",
    "토요일",
    "일요일",
  ];

  for (WorkingStatus status in history) {
    DateTime start = DateTime.fromMillisecondsSinceEpoch(status.startEpoch);
    DateTime end = DateTime.fromMillisecondsSinceEpoch(status.endEpoch);
    Duration gap = end.difference(start);

    totalMinutes[start.weekday] += gap.inMinutes;
    workCount[start.weekday]++;
  }
  int maxTime = 0;
  int maxWeek = 0;

  for (int i = 0; i < 10; i++) {
    if (workCount[i] != 0) {
      if (maxTime < totalMinutes[i] ~/ workCount[i]) {
        maxTime = totalMinutes[i] ~/ workCount[i];
        maxWeek = i;
      }
    }
  }
  return weekday[maxWeek];
}
