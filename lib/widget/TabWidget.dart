import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class TabWidget extends StatefulWidget {
  final Function call;
  final List<String> list;
  final int currentIndex = 0;

  const TabWidget({Key key, this.call, this.list}) : super(key: key);

  @override
  _TabWidgetState createState() => _TabWidgetState(currentIndex);
}

class _TabWidgetState extends State<TabWidget> {
  var currentIndex;

  _TabWidgetState(int i) {
    currentIndex = i;
  }

  call(index, str) {
    widget.call(index, str);

    currentIndex = index;

    print(index.toString());

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {


    Map<int, String> map = widget.list.asMap();

    List<Widget> widgets = map.keys.map((e) {
      return Expanded(
        flex: 1,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(
                color: currentIndex == e ? Colors.red : Colors.black,
                width: 1,
                style: BorderStyle.solid),
          )),
          child: FlatButton(
            child: Text(
              map[e],
              style: TextStyle(
                  color: currentIndex == e ? Colors.red : Colors.black),
            ),
            onPressed: () {
              call(e, map[e]);
            },
          ),
        ),
      );
    }).toList();

    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widgets,
      ),
    );
  }
}
