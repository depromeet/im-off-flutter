import 'package:flutter/widgets.dart';
import 'package:im_off/screen/setting_screen/custom_picker.dart';

List<String> pmAm = ['오전', '오후'];

List<String> hours = List.generate(
  12,
  (i) => (i + 1 < 10) ? "0${i + 1}" : (i + 1).toString(),
);
List<String> minutes = List.generate(
  60,
  (i) => (i < 10) ? "0$i" : i.toString(),
);
