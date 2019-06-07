import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:im_off/model/working_status.dart';
import 'package:provider/provider.dart';
import '../../bloc/navigation_bloc.dart';

import '../setting_screen/setting_screen.dart';

class TextIndicator extends StatelessWidget {
  TextIndicator({
    @required this.status,
  });
  final WorkingStatus status;

  @override
  Widget build(BuildContext context) {
    var navStreamController =
        Provider.of<StreamController<NavigationEvent>>(context);
    return Container(
      padding: EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTitle(),
          SizedBox(height: 8.0),
          _buildDesc(),
          Spacer(),
          _buildShowHistory(navStreamController),
        ],
      ),
    );
  }

  Widget _buildShowHistory(StreamController controller) {
    return CupertinoButton(
      minSize: 24.0,
      padding: EdgeInsets.zero,
      onPressed: () {
        controller.add(NavigationEvent.gotoHistory);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "내 칼퇴 기록보기",
            style: const TextStyle(
              color: const Color(0xff191919),
              fontWeight: FontWeight.w300,
              fontFamily: "SpoqaHanSans",
              fontStyle: FontStyle.normal,
              fontSize: 16.0,
            ),
          ),
          SizedBox(width: 8.0),
          Image.asset('images/down_btn.png'),
        ],
      ),
    );
  }

  Text _buildDesc() {
    String text = "퇴근 시간 확인중";
    DateTime now = DateTime.now();
    if (status != null) {
      int workingMinutes =
          status.setting.endMinute - status.setting.startMinute;
      if (status.startEpoch != null) {
        // 출근 했다.
        DateTime started =
            DateTime.fromMillisecondsSinceEpoch(status.startEpoch);
        DateTime expectedOff = started.add(Duration(minutes: workingMinutes));
        if (status.endEpoch != null) {
          // 퇴근 했다.
          DateTime offTime =
              DateTime.fromMillisecondsSinceEpoch(status.endEpoch);
          int endInMinutes = offTime.hour * 60 + offTime.minute;
          String stringTime = minutesToString(endInMinutes, toText: true);

          // 15 분 정도 늦게 나간건 칼퇴야
          expectedOff = expectedOff.add(Duration(minutes: 15));

          if (offTime.isAfter(expectedOff)) {
            // 야근 해버렸음
            text = stringTime + " 퇴근";
          } else {
            // 칼퇴 해버렸음
            text = stringTime + " 칼퇴 성공!";
          }
        } else {
          // 아직 근무 중이다.
          if (now.isAfter(expectedOff)) {
            // 야근 중이다.
            Duration overWorking = now.difference(expectedOff);
            if (overWorking.inMinutes >= 60) {
              // 1시간 넘게 야근 중
              text =
                  "${overWorking.inHours}시간 ${overWorking.inMinutes % 60}분 더 일하는 중...";
            } else {
              // 1시간 미만으로 야근 중
              text = "${overWorking.inMinutes}분 더 일하는 중...";
            }
          } else {
            // 야근이 아니다
            String stringTime =
                minutesToString(status.setting.endMinute, toText: true);
            text = stringTime + " 퇴근";
          }
        }
      } else if (status.isWeekDay) {
        // 아직 출근 안했다.
        text = "출근 준비!";
      }
      if (!status.isWeekDay) {
        if (now.weekday == DateTime.saturday) {
          text = "내일도 쉬는날!";
        } else {
          text = "내일은 월요일...";
        }
      }
    }

    return Text(
      text,
      style: const TextStyle(
        color: const Color(0xff191919),
        fontWeight: FontWeight.w300,
        fontFamily: "SpoqaHanSans",
        fontStyle: FontStyle.normal,
        fontSize: 20.0,
        height: 1 + 24.0 / 20.0,
      ),
    );
  }

  Text _buildTitle() {
    // TODO: 야근 시 경고 문구 표시하기
    int weekday = DateTime.now().weekday;
    DateTime now = DateTime.now();
    String ment = encourageMent[weekday - 1];
    if (status != null) {
      if (status.isWeekDay) {
        if (status.startEpoch != null) {
          // 출근 하긴 했어유
          int workingHours =
              status.setting.endMinute - status.setting.startMinute;
          DateTime started =
              DateTime.fromMillisecondsSinceEpoch(status.startEpoch);
          DateTime expectedOff = started.add(Duration(minutes: workingHours));
          if (status.endEpoch != null) {
            // 퇴근 해버렸어유
            DateTime offDate =
                DateTime.fromMillisecondsSinceEpoch(status.endEpoch);
            Duration worked = offDate.difference(started);
            if (worked.inMinutes <= workingHours + 15) {
              // 15 분 까지는 칼퇴로 쳐줌 ㅋ
              ment = finishMent[0];
            } else {
              ment = finishMent[1];
            }
          } else {
            // 아직 퇴근 못했어유
            if (now.isAfter(expectedOff)) {
              // 야근 중이에요
              ment = alertMent;
            }
          }
        }
      }
    }
    return Text(
      ment,
      style: const TextStyle(
        color: const Color(0xff191919),
        fontWeight: FontWeight.w400,
        fontFamily: "JalnanOTF",
        fontStyle: FontStyle.normal,
        fontSize: 34.0,
        height: 1 + 12.0 / 34.0,
      ),
    );
  }
}

const List<String> encourageMent = [
  "피곤한 월요일\n오늘 꼭 칼퇴하세요.",
  "숨 가쁜 화요일\n오늘 꼭 칼퇴하세요.",
  "지치는 수요일\n오늘 꼭 칼퇴하세요.",
  "아직도 목요일\n오늘 꼭 칼퇴하세요.",
  "불타는 금요일\n오늘 꼭 칼퇴하세요.",
  "드디어 토요일\n돼지런하게 보내요.",
  "즐거운 일요일\n돼지런하게 보내요.",
];

const String alertMent = "야근중입니다.\n어서 퇴근하세요!";

const List<String> finishMent = [
  "축하합니다.\n칼퇴하셨군요!",
  "야근하셨군요...\n내일은 꼭 칼퇴를!",
];
