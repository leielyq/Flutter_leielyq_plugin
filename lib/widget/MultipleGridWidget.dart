import 'package:flutter/widgets.dart';

abstract class MultipleGridItemBuilderDelegate<T> {
  Widget build(BuildContext context, int index, T data);
}

class MultipleGridWidget<T> extends StatelessWidget {
  final List<T> list;
  final Widget child;
  final MultipleGridItemBuilderDelegate<T> multipleGridItemBuilderDelegate;

  const MultipleGridWidget(
      {Key key, this.list, this.child, this.multipleGridItemBuilderDelegate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w1 = MediaQuery
        .of(context)
        .size
        .width / 1;

    double w2 = MediaQuery
        .of(context)
        .size
        .width / 2;

    double w3 = MediaQuery
        .of(context)
        .size
        .width / 3;


    if (list == null) return Container();

//    if (list.length == 1) {
//      return multipleGridItemBuilderDelegate.build(context, 0, list[0]);
//    }

    int i = list.length;
    int h = i < 4 ? 1 : i < 7 ? 2 : 3;

    if (i == 1) {
      return Container(
        width: w3,
        height: w3,
        child: multipleGridItemBuilderDelegate.build(context, 0, list[0]),
      );
    } else {
      List<Widget> widgets = List();
      for (int i = 0; i < list.length; i++) {
        Widget item = Container(
          width: w3,
          height: 200/h,
          child: multipleGridItemBuilderDelegate.build(context, i, list[i]),
        );
        widgets.add(item);
      }

      return Wrap(
        children: widgets,
      );
    }
  }
}
