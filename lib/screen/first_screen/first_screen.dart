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
              TextIndicator(
                status: status,
              ),
              Positioned(
                bottom: 88.0,
                left: -28.0,
                child: ChartIndicator(status: status),
              ),
              Positioned(
                bottom: 113.0,
                left: 220.0,
                child: BlueButton(status: status),
              ),
            ],
          );
        },
      ),
    );
  }
}

class BlueButton extends StatelessWidget {
  BlueButton({
    this.status,
  });
  final WorkingStatus status;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 90,
        height: 90,
        decoration: ShapeDecoration(
          shape: CircleBorder(),
          color: Color(0xff3a2eff),
        ),
        child: Center(
          child: Text(
            "퇴근",
            style: const TextStyle(
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w700,
              fontFamily: "SpoqaHanSans",
              fontStyle: FontStyle.normal,
              fontSize: 22.0,
            ),
          ),
        ),
      ),
    );
  }
}
