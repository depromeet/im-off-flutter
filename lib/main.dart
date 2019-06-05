import 'dart:async';
import 'dart:math';
import 'dart:convert';

import 'package:easy_stateful_builder/easy_stateful_builder.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_off/model/working_status.dart';
import 'package:provider/provider.dart';

import 'package:im_off/screen/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/navigation_bloc.dart';
import 'bloc/setting_bloc.dart';

import 'screen/routes.dart';
import 'model/constant.dart';
import 'model/user_setting.dart';

void main() {
//  timeDilation = 2.0;
  runApp(IamOff());
}

class IamOff extends StatelessWidget {
  // This widget is the root of your application.
  static final SettingBloc _settingBloc = SettingBloc();
  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders: [
        BlocProvider<SettingBloc>(bloc: _settingBloc),
      ],
      child: CupertinoApp(
        title: 'Flutter Demo',
        initialRoute: IamOffRoute.splashScreen,
        onGenerateRoute: (RouteSettings route) {
          switch (route.name) {
            case IamOffRoute.home:
              return CupertinoPageRoute(
                builder: (context) {
                  return IamOffMain();
                },
              );
            case IamOffRoute.splashScreen:
              return CupertinoPageRoute(
                builder: (context) {
                  return SplashScreen();
                },
              );
            case IamOffRoute.settings:
              return CupertinoPageRoute(
                builder: (context) {
                  return SettingScreen();
                },
                settings: route,
              );
            default:
              print("Should not be here");
          }
        },
      ),
    );
  }
}

class IamOffMain extends StatefulWidget {
  @override
  _IamOffMainState createState() => _IamOffMainState();
}

class _IamOffMainState extends State<IamOffMain> {
  final StreamController<NavigationEvent> navigationStream =
      StreamController<NavigationEvent>();

  final PageController _pageController = PageController(
    keepPage: true,
    initialPage: 0,
  );

  Timer workingTimer;

  @override
  void initState() {
    super.initState();

    this._loadWorkingStatus();

    // 1분 마다 출퇴근 상태 확인
    workingTimer =
        Timer.periodic(Duration(minutes: 1), (_) => this._loadWorkingStatus());
  }

  @override
  void dispose() {
    navigationStream.close();
    workingTimer.cancel();
    super.dispose();
  }

  void _loadWorkingStatus() async {
    DateTime now = DateTime.now();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String workingStatusJson = prefs.getString(workingStatusKey);
    String userSettingJson = prefs.getString(settingsKey);
    UserSetting setting = UserSetting();
    if (userSettingJson != null) {
      setting = UserSetting.fromJson(jsonDecode(userSettingJson));
    }
    WorkingStatus stat = WorkingStatus();

    if (workingStatusJson != null) {
      stat = WorkingStatus.fromJson(jsonDecode(workingStatusJson));
    }
    stat.setting = setting;

    if (stat.endEpoch != null) {
      if (DateTime.fromMillisecondsSinceEpoch(stat.startEpoch).isBefore(now)) {
        // 전날 출퇴근 기록이 있고, 다음날이 시작 됐을 경우 초기화
        stat.endEpoch = null;
        stat.startEpoch = null;
      }
    }

    // 아직 출근 기록이 없을 경우
    if (stat.startEpoch == null) {
      if (now.weekday == DateTime.saturday || now.weekday == DateTime.sunday) {
        // 주말 인 경우
        stat.isWeekDay = false;
      } else {
        stat.isWeekDay = true;
        if (now.minute + now.hour * 60 >= setting.startMinute) {
          // 출근 시간이 지난 경우, 자동으로 출근 시간 체크
          DateTime startDate = DateTime(
            now.year,
            now.month,
            now.day,
            (setting.startMinute ~/ 60),
            setting.startMinute % 60,
          );
          stat.startEpoch = startDate.millisecondsSinceEpoch;
        } else {
          // 출근 시간이 안 지난 경우, 아직 출근 준비중
        }
      }
    }
    stat.saveStatus();
    EasyStatefulBuilder.setState(workingStatusKey, (state) {
      state.nextState = stat;
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = StreamProvider.value(
      stream: navigationStream.stream,
      initialData: NavigationEvent.first,
      updateShouldNotify: (oldEvent, newEvent) {
        switch (newEvent) {
          case NavigationEvent.gotoMain:
            this._gotoPage(0);
            break;
          case NavigationEvent.gotoHistory:
            this._gotoPage(1);
            break;
        }
        return false;
      },
    );
    return MultiProvider(
      providers: [
        navigationProvider,
        Provider<StreamController<NavigationEvent>>.value(
          value: navigationStream,
        ),
      ],
      child: PageView(
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        controller: _pageController,
        children: <Widget>[
          FirstScreen(),
          SecondScreen(),
        ],
      ),
    );
  }

  void _gotoPage(int idx) {
    _pageController.animateToPage(
      idx,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }
}
