import 'dart:async';

import 'package:easy_stateful_builder/easy_stateful_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_off/bloc/setting_bloc.dart';
import 'package:im_off/model/constant.dart';
import 'package:im_off/model/user_setting.dart';
import 'package:im_off/model/working_status.dart';
import 'package:provider/provider.dart';
import 'package:im_off/bloc/navigation_bloc.dart';

import 'off_card.dart';

const List<String> weekday = [
  "기록 없음",
  "월요일",
  "화요일",
  "수요일",
  "목요일",
  "금요일",
  "토요일",
  "일요일",
];

const List<String> engWeekday = [
  "",
  "Mon",
  "Tue",
  "Wed",
  "Thu",
  "Fri",
  "Sat",
  "Sun",
];

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  void initState() {
    super.initState();
    WorkingStatus.getHistory();
  }

  @override
  Widget build(BuildContext context) {
    StreamController navController =
        Provider.of<StreamController<NavigationEvent>>(context);
    return CupertinoPageScaffold(
      backgroundColor: Color(0xfff7f7f7),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            _buildTitle(navController),
            _buildHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildHistory() {
    return EasyStatefulBuilder(
        identifier: workingHistoryKey,
        initialValue: null,
        keepAlive: true,
        builder: (context, WorkingHistory snapshot) {
          UserSetting setting =
              BlocProvider.of<SettingBloc>(context).currentState.settings;
          String weekWorkingHours;
          String avgEndMinute;
          String getOffCriteria = "/18시 00분";
          int minWorkingDay = 0;
          int maxWorkingDay = 0;
          int workingStartMinute = 0;
          int workingGap = 0;
          if (setting?.startMinute != null) {
            workingStartMinute = setting.startMinute;
          }
          if (snapshot != null) {
            minWorkingDay = snapshot.fastOffWeekday;
            maxWorkingDay = snapshot.extraWorkingWeekday;
            weekWorkingHours = "${snapshot.workingHoursAWeek}시간 ";
            if (snapshot.avgOffTimeInMinute == 0) {
              avgEndMinute = "기록 없음 ";
            } else {
              int hour = snapshot.avgOffTimeInMinute ~/ 60;
              int minute = snapshot.avgOffTimeInMinute % 60;
              avgEndMinute = ((hour < 10) ? "0" : "") +
                  "$hour시 " +
                  ((minute < 10) ? "0" : "") +
                  "$minute분 ";
              workingGap = snapshot.avgOffTimeInMinute - workingStartMinute;
            }
          }
          if (setting?.endMinute != null) {
            int hour = setting.endMinute ~/ 60;
            int minute = setting.endMinute % 60;
            getOffCriteria = "/" +
                ((hour < 10) ? "0" : "") +
                "$hour시 " +
                ((minute < 10) ? "0" : "") +
                "$minute분";
          }
          return Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 4.0),
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                Center(
                  child: OffCard(
                    title: "이번주 근무 시간",
                    chartColor: Color(0xff25f2ff),
                    statistic: weekWorkingHours ?? "계산중 ",
                    criteria: weekWorkingHours == null ? "" : "/52시간",
                    startMinute: 0,
                    gapMinute: 720 * ((snapshot?.workingHoursAWeek) ?? 0) ~/ 52,
                  ),
                ),
                Center(
                  child: OffCard(
                    title: "평균 퇴근 시간",
                    chartColor: Color(0xff3a2eff),
                    statistic: avgEndMinute ?? "계산중 ",
                    criteria: avgEndMinute == null ? "" : getOffCriteria,
                    startMinute: workingStartMinute,
                    gapMinute: workingGap,
                  ),
                ),
                Center(
                  child: OffCard(
                    title: "주로 칼퇴하는 요일",
                    chartColor: Color(0xff25f2ff),
                    startMinute: 0,
                    gapMinute: 720,
                    statistic: weekday[minWorkingDay],
                    chartTitle: engWeekday[minWorkingDay],
                  ),
                ),
                Center(
                  child: OffCard(
                    title: "주로 야근하는 요일",
                    chartColor: Color(0xffff295b),
                    startMinute: 0,
                    gapMinute: 720,
                    statistic: weekday[maxWorkingDay],
                    chartTitle: engWeekday[maxWorkingDay],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Padding _buildTitle(StreamController navController) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 44.0,
        bottom: 26.0,
        left: 30.0,
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        minSize: 18.0,
        onPressed: () {
          navController.add(NavigationEvent.gotoMain);
        },
        child: Row(
          children: <Widget>[
            Text(
              "내 칼퇴 기록",
              style: const TextStyle(
                color: const Color(0xff191919),
                fontWeight: FontWeight.w400,
                fontFamily: "JalnanOTF",
                fontStyle: FontStyle.normal,
                fontSize: 22.0,
              ),
            ),
            SizedBox(width: 18.0),
            Image.asset(
              'images/up_btn.png',
              width: 18.0,
              height: 18.0,
            ),
          ],
        ),
      ),
    );
  }
}
