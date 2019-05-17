import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:im_off/bloc/navigation_bloc.dart';

import 'off_card.dart';

class SecondScreen extends StatelessWidget {
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

  Expanded _buildHistory() {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.only(top: 4.0),
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          Center(
            child: OffCard(),
          ),
          Center(
            child: OffCard(),
          ),
          Center(
            child: OffCard(),
          ),
          Center(
            child: OffCard(),
          ),
        ],
      ),
    );
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
