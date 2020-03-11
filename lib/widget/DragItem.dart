import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DragItem extends StatefulWidget {
  final String url;

  const DragItem({Key key, this.url}) : super(key: key);

  @override
  _DragItemState createState() => _DragItemState();
}

class _DragItemState extends State<DragItem> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.getInstance().init(context);
    var w = ScreenUtil.getInstance()
        .setWidth((ScreenUtil.getInstance().width - 40) ~/ 3);

//    var widget = Container(
//      color: Colors.blue,
//      height: w,
//      width: w,
//      child: Stack(
//        fit: StackFit.passthrough,
//        children: <Widget>[
//          Positioned(
//              child: Image.network(
//                widget.url,
//                fit: BoxFit.cover,
//              )),
//          Positioned(
//            top: 0,
//            right: 0,
//            child: Icon(
//              Icons.cancel,
//            ),
//          )
//        ],
//      ),
//    );
    var widget = null;

    return DragTarget(onWillAccept: (data) {
      print("data = $data onWillAccept");
      return data != null; //当Draggable传递过来的dada不是null的时候 决定接收该数据。
    }, onAccept: (data) {
      print("data = $data onAccept");
    }, onLeave: (data) {
      print("data = $data onLeave"); //我来了 我又走了
    }, builder: (context, candidateData, rejectedData) {
      return Container(
        child: LongPressDraggable(
          child: widget,
          feedback: widget,
          data: widget.url,
        ),
      );
    });
  }
}
