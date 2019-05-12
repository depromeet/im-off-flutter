import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:im_off/screen/screen.dart';

import 'bloc/navigation_bloc.dart';

StreamController<NavigationEvent> navigationStream =
    StreamController<NavigationEvent>();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders: [],
      child: CupertinoApp(
        title: 'Flutter Demo',
        initialRoute: '/',
        onGenerateRoute: (RouteSettings route) {
          switch (route.name) {
            case '/':
              return CupertinoPageRoute(
                builder: (context) {
                  return IamOffApp();
                },
              );
            case '/settings':
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

class IamOffApp extends StatelessWidget {
  final PageController _pageController = PageController(
    keepPage: true,
    initialPage: 0,
  );
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
