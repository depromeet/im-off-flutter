import 'package:flutter/cupertino.dart';

enum FieldDirection { vertical, horizontal }

class CustomPicker extends StatelessWidget {
  final FieldDirection direction;
  final int numFields;
  final Map<String, List> fieldItems;
  final bool showFieldName;
  final TextStyle textStyle;

  CustomPicker({
    this.direction,
    this.numFields = 1,
    this.fieldItems,
    this.showFieldName = false,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
