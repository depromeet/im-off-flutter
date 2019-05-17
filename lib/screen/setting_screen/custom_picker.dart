import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum FieldDirection { vertical, horizontal }

class CustomPicker extends StatelessWidget {
  final FieldDirection direction;
  final List<ItemList> fields;
  final bool showFieldName;
  final TextStyle selectedTextStyle;
  final TextStyle unselectedTextStyle;
  final String title;
  final double height;
  final double width;

  CustomPicker({
    this.direction = FieldDirection.horizontal,
    @required this.fields,
    this.showFieldName = false,
    this.title,
    this.unselectedTextStyle = const TextStyle(
      color: const Color(0xffb5b5b5),
      fontWeight: FontWeight.w400,
      fontFamily: "JalnanOTF",
      fontStyle: FontStyle.normal,
      fontSize: 18.0,
    ),
    this.selectedTextStyle = const TextStyle(
      color: const Color(0xff191919),
      fontWeight: FontWeight.w400,
      fontFamily: "JalnanOTF",
      fontStyle: FontStyle.normal,
      fontSize: 18.0,
    ),
    this.height = 372.0,
    this.width = 300.0,
  });

  @override
  Widget build(BuildContext context) {
    List<FixedExtentScrollController> controllers = [];
    for (int i = 0; i < this.fields.length; i++) {
      controllers.add(FixedExtentScrollController());
    }
    return Center(
      child: Container(
        width: this.width,
        height: this.height,
        padding: EdgeInsets.only(top: 30.0),
        decoration: ShapeDecoration(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          color: Color(0xfff3f3f3),
        ),
        child: Stack(
          children: [
            SelectedItemIndicator(width: width),
            MultipleItemSelector(
                fields: fields,
                width: width,
                selectedTextStyle: selectedTextStyle,
                unselectedTextStyle: unselectedTextStyle,
                controllers: controllers),
          ],
        ),
      ),
    );
  }
}

class SelectedItemIndicator extends StatelessWidget {
  const SelectedItemIndicator({
    Key key,
    @required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: this.width,
      child: ListWheelScrollView.useDelegate(
        physics: FixedExtentScrollPhysics(
          parent: ClampingScrollPhysics(),
        ),
        diameterRatio: 50.0,
        itemExtent: 46.0,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: 1,
          builder: (context, index) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: constraints.maxWidth,
                  color: Color(0xffffffff),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class MultipleItemSelector extends StatelessWidget {
  const MultipleItemSelector({
    Key key,
    @required this.fields,
    @required this.width,
    @required this.selectedTextStyle,
    @required this.unselectedTextStyle,
    @required this.controllers,
  }) : super(key: key);

  final List<ItemList> fields;
  final double width;
  final TextStyle selectedTextStyle;
  final TextStyle unselectedTextStyle;
  final List<FixedExtentScrollController> controllers;

  @override
  Widget build(BuildContext context) {
    int selectedItem = 0;
    return Row(
      children: <Widget>[
        ...this
            .fields
            .asMap()
            .map((int controlIndex, ItemList list) {
              FixedExtentScrollController controller =
                  controllers[controlIndex];
              return MapEntry(
                controlIndex,
                StatefulBuilder(builder: (context, setState) {
                  return SizedBox(
                    width: this.width / this.fields.length,
                    child: ListWheelScrollView.useDelegate(
                      controller: controller,
                      physics: FixedExtentScrollPhysics(
                        parent: ClampingScrollPhysics(),
                      ),
                      diameterRatio: 50.0,
                      itemExtent: 46.0,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedItem = index;
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: list.items.length,
                        builder: (context, index) {
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              return Container(
                                padding: EdgeInsets.only(
                                  left: 30 +
                                      ((this.fields.length == 1) ? 26.0 : 0.0),
                                ),
                                width: constraints.maxWidth,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    list.items[index].toString(),
                                    style: index == selectedItem
                                        ? this.selectedTextStyle
                                        : this.unselectedTextStyle,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );
                }),
              );
            })
            .values
            .toList(),
      ],
    );
  }
}

class ItemList {
  final String listTitle;
  final List items;
  const ItemList({@required this.items, this.listTitle});
}
