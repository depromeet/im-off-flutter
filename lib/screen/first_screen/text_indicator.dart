import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../bloc/navigation_bloc.dart';

class TextIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var navStreamController =
        Provider.of<StreamController<NavigationEvent>>(context);
    return Container(
      padding: EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTitle(),
          SizedBox(height: 8.0),
          _buildDesc(),
          Spacer(),
          _buildShowHistory(navStreamController),
        ],
      ),
    );
  }

  Widget _buildShowHistory(StreamController controller) {
    return CupertinoButton(
      minSize: 24.0,
      padding: EdgeInsets.zero,
      onPressed: () {
        controller.add(NavigationEvent.gotoHistory);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "내 칼퇴 기록보기",
            style: const TextStyle(
              color: const Color(0xff191919),
              fontWeight: FontWeight.w300,
              fontFamily: "SpoqaHanSans",
              fontStyle: FontStyle.normal,
              fontSize: 16.0,
            ),
          ),
          SizedBox(width: 8.0),
          Image.asset('images/down_btn.png'),
        ],
      ),
    );
  }

  Text _buildDesc() {
    return Text(
      "오후 10시 42분 퇴근",
      style: const TextStyle(
        color: const Color(0xff191919),
        fontWeight: FontWeight.w300,
        fontFamily: "SpoqaHanSans",
        fontStyle: FontStyle.normal,
        fontSize: 20.0,
        height: 1 + 24.0 / 20.0,
      ),
    );
  }

  Text _buildTitle() {
    return Text(
      "피곤한 월요일\n오늘 꼭 칼퇴하세요.",
      style: const TextStyle(
        color: const Color(0xff191919),
        fontWeight: FontWeight.w400,
        fontFamily: "JalnanOTF",
        fontStyle: FontStyle.normal,
        fontSize: 34.0,
        height: 1 + 12.0 / 34.0,
      ),
    );
  }
}
