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
    // TODO: 요일별로 응원 문구 다르게 하기
    // TODO: 야근 시 경고 문구 표시하기
    // TODO: 퇴근 후 상황에 맞는 마무리 문구 표시 하기
    int weekday = DateTime.now().weekday;
    String ment = encourageMent[weekday - 1];
    return Text(
      ment,
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

const List<String> encourageMent = [
  "피곤한 월요일\n오늘 꼭 칼퇴하세요.",
  "숨 가쁜 화요일\n오늘 꼭 칼퇴하세요.",
  "지치는 수요일\n오늘 꼭 칼퇴하세요.",
  "아직도 목요일\n오늘 꼭 칼퇴하세요.",
  "불타는 금요일\n오늘 꼭 칼퇴하세요.",
  "드디어 토요일\n돼지런하게 보내요.",
  "즐거운 일요일\n돼지런하게 보내요.",
];

const String alertMent = "야근중입니다.\n어서 퇴근하세요!";

const List<String> finishMent = [
  "축하합니다.\n칼퇴하셨군요!",
  "야근하셨군요...\n내일은 꼭 칼퇴를!",
];
