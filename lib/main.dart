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
              );
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

  @override
  void initState() {
    super.initState();
    this._loadOffState();
  }

  @override
  void dispose() {
    navigationStream.close();
    super.dispose();
  }

  void _loadOffState() async {
    DateTime now = DateTime.now();
    if (now.weekday == DateTime.saturday || now.weekday == DateTime.sunday) {
      // 주말인 경우
      WorkingStatus stat = WorkingStatus(isWeekDay: false);
      EasyStatefulBuilder.setState(workingStatusKey, (state) {
        state.nextState = stat;
      });
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String workingStatusJson = prefs.getString(workingStatusKey);
      String userSettingJson = prefs.getString(settingsKey);
      UserSetting setting = UserSetting.fromJson(jsonDecode(userSettingJson));
      WorkingStatus stat = WorkingStatus();
      if (workingStatusJson != null) {
        stat = WorkingStatus.fromJson(jsonDecode(workingStatusJson));
      }
      stat.setting = setting;
      // 주중인데 일을 시작 안했거나, 아직 퇴근 안했을 경우
      if (stat.startTimeInMinute == null || stat.endTimeInMinute == null) {
        if (now.minute + now.hour * 60 >= setting.startMinute) {
          stat.startTimeInMinute = setting.startMinute;
        }
      }
      prefs.setString(workingStatusKey, jsonEncode(stat));
      EasyStatefulBuilder.setState(workingStatusKey, (state) {
        state.nextState = stat;
      });
    }
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
