import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Currently this package supports horizontal view only.
enum FieldDirection { vertical, horizontal }

/// CustomPicker for im_off app
/// This returns List<Item> for selected items or null.
class CustomPicker extends StatefulWidget {
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
  _CustomPickerState createState() => _CustomPickerState();
}

typedef OnItemSelectFunction = Function(int, dynamic);

class _CustomPickerState extends State<CustomPicker> {
  List<Item> _result;
  List<FixedExtentScrollController> controllers = [];

  @override
  void initState() {
    super.initState();
    _result = List.generate(
      widget.fields.length,
      (index) {
        int init = widget.fields[index].initialItemIndex ?? 0;
        if (init < 0) {
          init = widget.fields[index].items.length - 1;
          widget.fields[index].initialItemIndex = init;
        }
        controllers.add(
          FixedExtentScrollController(
            initialItem: init,
          ),
        );
        return Item(
          index: init,
          value: widget.fields[index].items[init],
        );
      },
    );
  }

  @override
  void dispose() {
    controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: this.widget.width,
        height: this.widget.height,
        padding: EdgeInsets.only(top: 30.0),
        decoration: ShapeDecoration(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          color: Color(0xfff3f3f3),
        ),
        child: Stack(
          children: [
            SelectedItemIndicator(width: widget.width),
            MultipleItemSelector(
              fields: widget.fields,
              width: widget.width,
              selectedTextStyle: widget.selectedTextStyle,
              unselectedTextStyle: widget.unselectedTextStyle,
              controllers: controllers,
              onItemSelected: this._onItemSelected,
            ),
            ConfirmButton(
              width: widget.width,
              getResult: this._getResult,
            ),
          ],
        ),
      ),
    );
  }

  void _onItemSelected(int index, item) => _result[index] = item;

  void _getResult() => this._result;
}

class Item {
  final int index;
  final value;
  Item({this.index, this.value});
  String toString() => '$index: $value';
}

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({
    Key key,
    @required this.width,
    @required this.getResult,
  }) : super(key: key);

  final double width;
  final Function getResult;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      child: Container(
        height: 24.0 * 3,
        color: Color(0xfff3f3f3),
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            CupertinoButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: ButtonText(
                title: '취소',
                isDestructive: true,
              ),
            ),
            CupertinoButton(
              onPressed: () {
                Navigator.of(context).pop(
                  this.getResult(),
                );
              },
              child: ButtonText(
                title: '확인',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonText extends StatelessWidget {
  final String title;
  final bool isDestructive;

  ButtonText({this.title, this.isDestructive = false});
  @override
  Widget build(BuildContext context) {
    return Text(
      this.title,
      style: TextStyle(
        color: this.isDestructive ? const Color(0xff191919) : Color(0xff3a2eff),
        fontWeight: FontWeight.w400,
        fontFamily: "SpoqaHanSans",
        fontStyle: FontStyle.normal,
        fontSize: 16.0,
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
    @required this.onItemSelected,
  }) : super(key: key);

  final List<ItemList> fields;
  final double width;
  final TextStyle selectedTextStyle;
  final TextStyle unselectedTextStyle;
  final List<FixedExtentScrollController> controllers;
  final OnItemSelectFunction onItemSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ...this
            .fields
            .asMap()
            .map((int controlIndex, ItemList list) {
              // Start of the real widget
              FixedExtentScrollController controller =
                  controllers[controlIndex];
              int selectedItem = controller.initialItem;
              return MapEntry(
                controlIndex,
                StatefulBuilder(builder: (context, setState) {
                  return SizedBox(
                    width: this.width / this.fields.length,
                    child: ListWheelScrollView.useDelegate(
                      controller: controller,
                      physics: FixedExtentScrollPhysics(),
                      diameterRatio: 50.0,
                      itemExtent: 46.0,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedItem = index;
                          this.onItemSelected(
                            controlIndex,
                            Item(
                              index: index,
                              value: list.items[index],
                            ),
                          );
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
                                child: GestureDetector(
                                  onTapUp: (_) {
                                    print("$index is clicked");
                                    controller.animateToItem(
                                      index,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeIn,
                                    );
                                  },
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      list.items[index].toString(),
                                      style: index == selectedItem
                                          ? this.selectedTextStyle
                                          : this.unselectedTextStyle,
                                    ),
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
  int initialItemIndex;

  ItemList({
    @required this.items,
    this.listTitle,
    this.initialItemIndex = 0,
  });

  ItemList copy() => ItemList(
        items: this.items,
        listTitle: this.listTitle,
        initialItemIndex: this.initialItemIndex,
      );
}
