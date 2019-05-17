import 'dart:async';

import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:im_off/screen/screen.dart';

import 'bloc/navigation_bloc.dart';
import 'bloc/setting_bloc.dart';

import 'screen/routes.dart';

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
  void dispose() {
    navigationStream.close();
    super.dispose();
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
