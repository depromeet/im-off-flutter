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
        keepAlive: true,
        builder: (context, WorkingStatus status) {
          ButtonType buttonType = ButtonType.getOff;
          if (status?.endEpoch != null && status?.startEpoch != null) {
            buttonType = ButtonType.share;
          } else if (status?.startEpoch == null) {
            buttonType = ButtonType.gotoWork;
          } else {
            print(DateTime.fromMillisecondsSinceEpoch(status.startEpoch));
          }

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
                child: BlueButton(type: buttonType),
              ),
            ],
          );
        },
      ),
    );
  }
}

enum ButtonType { gotoWork, getOff, share }

class BlueButton extends StatelessWidget {
  BlueButton({
    @required this.type,
  });
  final ButtonType type;
  @override
  Widget build(BuildContext context) {
    Function buttonAction;
    String title;
    switch (this.type) {
      case ButtonType.gotoWork:
        buttonAction = this._gotoWork;
        title = "출근";
        break;
      case ButtonType.getOff:
        buttonAction = this._getOff;
        title = "퇴근";
        break;
      case ButtonType.share:
        buttonAction = this._share;
        title = "공유";
        break;
    }
    return GestureDetector(
      onTap: buttonAction,
      child: Container(
        width: 90,
        height: 90,
        decoration: ShapeDecoration(
          shape: CircleBorder(),
          color: Color(0xff3a2eff),
        ),
        child: Center(
          child: Text(
            title,
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

  void _gotoWork() {
    EasyStatefulBuilder.setState(workingStatusKey, (state) {
      WorkingStatus status = state.currentState as WorkingStatus;
      status.startEpoch = DateTime.now().millisecondsSinceEpoch;
      status.saveStatus();
      state.nextState = status;
    });
  }

  void _getOff() {
    EasyStatefulBuilder.setState(workingStatusKey, (state) {
      WorkingStatus status = state.currentState as WorkingStatus;
      status.endEpoch = DateTime.now().millisecondsSinceEpoch;
      status.saveStatus();
      state.nextState = status;
    });
  }

  void _share() {
    // TODO : 스크린샷 찍어서 공유하기
  }
}
