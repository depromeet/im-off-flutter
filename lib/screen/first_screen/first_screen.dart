import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:im_off/bloc/navigation_bloc.dart';
import 'package:im_off/screen/first_screen/chart_indicator.dart';

import 'text_indicator.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white,
        border: Border(bottom: BorderSide.none),
        automaticallyImplyLeading: false,
        trailing: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          onPressed: () {
            Navigator.of(context).pushNamed('/settings');
          },
          child: Image.asset('images/setting_btn.png'),
        ),
      ),
      child: Stack(
        children: <Widget>[
          TextIndicator(),
          Positioned(
            top: 224.0,
            left: -30.0,
            child: ChartIndicator(),
          ),
        ],
      ),
    );
  }
}
