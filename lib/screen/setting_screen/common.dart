import 'package:flutter/cupertino.dart';

class JalnanTitle extends StatelessWidget {
  final String title;
  final double size;

  JalnanTitle({
    this.title,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      this.title,
      style: TextStyle(
        color: const Color(0xff191919),
        fontWeight: FontWeight.w400,
        fontFamily: "JalnanOTF",
        fontStyle: FontStyle.normal,
        fontSize: this.size,
      ),
    );
  }
}
