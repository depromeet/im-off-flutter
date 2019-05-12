import 'package:flutter/cupertino.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            SettingMain(),
          ],
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
          SettingSelector(),
        ],
      ),
    );
  }
}

class SettingSelector extends StatelessWidget {
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
              "출근시간",
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
