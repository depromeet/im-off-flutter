import 'package:flutter/cupertino.dart';
import 'package:im_off/screen/setting_screen/common.dart';
import 'package:im_off/screen/setting_screen/notification_switch.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            SettingMain(),
            Positioned(
              bottom: 30.0,
              right: 30.0,
              child: SettingDone(),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingDone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        decoration: ShapeDecoration(
          shape: CircleBorder(),
          color: Color(0xff3a2eff),
        ),
        width: 90.0,
        height: 90.0,
        child: Center(
          child: Text(
            "확인",
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

class SettingMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 28.0,
        horizontal: 30.0,
      ),
      child: ListView(
        children: <Widget>[
          SizedBox(height: 12.0),
          JalnanTitle(title: '출퇴근 시간을 설정해주세요.', size: 16.0),
          SizedBox(height: 16.0),
          SettingSelector(title: '출근시간'),
          SizedBox(height: 6.0),
          SettingSelector(title: '퇴근시간'),
          SizedBox(height: 50.0),
          JalnanTitle(title: '직군을 선택해주세요.', size: 16.0),
          SizedBox(height: 16.0),
          SettingSelector(title: '나의직군'),
          SizedBox(height: 50.0),
          NotificationSwitch(),
          SizedBox(height: 10.0),
          Text(
            "퇴근시간 후 30분 간격의 퇴근확인\n푸시알림이 발생합니다.",
            style: const TextStyle(
              color: const Color(0xff191919),
              fontWeight: FontWeight.w300,
              fontFamily: "SpoqaHanSans",
              fontStyle: FontStyle.normal,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}

class SettingSelector extends StatelessWidget {
  final String title;

  SettingSelector({
    this.title,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
        color: Color(0xfff3f3f3),
      ),
      child: CupertinoButton(
        onPressed: () {},
        padding: EdgeInsets.symmetric(
          horizontal: 14.0,
          vertical: 8.0,
        ),
        child: Row(
          children: <Widget>[
            Text(
              this.title,
              style: const TextStyle(
                color: const Color(0xff3c3c3c),
                fontWeight: FontWeight.w400,
                fontFamily: "JalnanOTF",
                fontStyle: FontStyle.normal,
                fontSize: 22.0,
              ),
            ),
            Spacer(),
            Image.asset(
              'images/icon_down.png',
              height: 26,
              width: 26,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
