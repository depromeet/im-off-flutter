import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

IOSInitializationSettings iosInitializationSettings = IOSInitializationSettings(
  onDidReceiveLocalNotification:
      (int id, String title, String body, String payload) async {
    // 로컬 노티 실행 됐을 때, ios 10 미만
  },
);

InitializationSettings initializationSettings = InitializationSettings(
    androidInitializationSettings, iosInitializationSettings);

const int periodicNotificationId = 0x66666666;
const int dailyNotificationId = 0x55555555;
const int periodicNotificationRepeat = 10;

void initFlutterLocalNotifications(SelectNotificationCallback callback) async {
  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String payload) async {
      for (int i = 0; i < periodicNotificationRepeat; i++) {
        flutterLocalNotificationsPlugin.cancel(periodicNotificationId + i);
      }
    },
  );
}

const List<String> pleaseGetOff = [
  '한번이 어렵지 두번은 쉽다. - 칼퇴',
  '빠르면 빠를수록 좋다. - 퇴근',
  '오늘 더 한다고 내일 줄지 않는다.',
  '내일의 나를 믿어보자.',
  '칼퇴라고 하지마요. 정시퇴근입니다.',
  '오늘 할 일을 내일로 미루자.',
];

Future registerDailyNotification(Time time) async {
  Random rand = Random();
  int mentNumber = rand.nextInt(pleaseGetOff.length);
  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'gotOff notification Channel',
      'gotOff notification Channel',
      '빨리 퇴근하라는 메시지');
  final iOSPlatformChannelSpecifics = IOSNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );
  final platformChannelSpecifics = NotificationDetails(
    androidPlatformChannelSpecifics,
    iOSPlatformChannelSpecifics,
  );

  print("Register notification on ${time.hour}:${time.minute}");
  await flutterLocalNotificationsPlugin.cancel(dailyNotificationId);
  await flutterLocalNotificationsPlugin.showDailyAtTime(
    dailyNotificationId,
    '퇴근하셨나요?',
    pleaseGetOff[mentNumber],
    time,
    platformChannelSpecifics,
  );
}

Future registerPeriodicNotification(Time notiTime, int everyMinute) async {
  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
    '칼퇴 안했을 때 주기적 알림 채널 아이디',
    '칼퇴 안했을 때 주기적 알림 채널',
    '빨리 퇴근하라는 메시지',
  );
  final iOSPlatformChannelSpecifics = IOSNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );
  final platformChannelSpecifics = NotificationDetails(
    androidPlatformChannelSpecifics,
    iOSPlatformChannelSpecifics,
  );
  Random rand = Random();
  int mentNumber = rand.nextInt(pleaseGetOff.length);

  for (int i = 0; i < periodicNotificationRepeat; i++) {
    DateTime temp = DateTime(1999, 1, 1, notiTime.hour, notiTime.minute);
    temp = temp.add(Duration(minutes: (i + 1) * everyMinute));

    flutterLocalNotificationsPlugin.showDailyAtTime(
      dailyNotificationId + i,
      '퇴근하셨나요?',
      pleaseGetOff[mentNumber],
      Time(temp.hour, temp.minute),
      platformChannelSpecifics,
    );
  }
}

Future cancleAllNotifications() async {
  flutterLocalNotificationsPlugin.cancelAll();
}
