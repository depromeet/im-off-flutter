import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:im_off/model/constant.dart';
import 'package:provider/provider.dart';
import 'package:easy_stateful_builder/easy_stateful_builder.dart';

import 'package:im_off/bloc/navigation_bloc.dart';
import 'package:im_off/screen/first_screen/chart_indicator.dart';

import 'text_indicator.dart';
import '../../model/working_status.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: 현재 출/근무/퇴근 중 어느 시점인지 확인해야 함.
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white,
        border: Border(bottom: BorderSide.none),
        automaticallyImplyLeading: false,
        trailing: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          onPressed: () {
            Navigator.of(context).pushNamed('/settings', arguments: true);
          },
          child: Image.asset('images/setting_btn.png'),
        ),
      ),
      child: EasyStatefulBuilder(
        identifier: workingStatusKey,
        builder: (context, status) {
          return Stack(
            children: <Widget>[
              TextIndicator(),
              Positioned(
                top: 224.0,
                left: -30.0,
                child: ChartIndicator(),
              ),
            ],
          );
        },
      ),
    );
  }
}
