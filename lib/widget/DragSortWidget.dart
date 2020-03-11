import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DragSortWidget<T> extends StatefulWidget {
  final List<T> list;
  final DragItemBuilderDelegate dragItemBuilderDelegate;
  final Widget endWidget;
  final Widget child;
  final int max;
  final CallBackDragSort callBackDragSort;

  const DragSortWidget(
      {Key key,
      this.list,
      this.dragItemBuilderDelegate,
      this.endWidget,
      this.child,
      this.max,
      this.callBackDragSort})
      : super(key: key);

  @override
  _DragSortWidgetState createState() {
    return _DragSortWidgetState<T>();
  }
}

abstract class DragItemBuilderDelegate<T> {
  Widget build(BuildContext context, int index, T data);
}

class CallBackDragSort<T> {
  List<T> _list;

  onList(List<T> datas) {
    _list = datas;
  }

  getList() {
    return _list;
  }
}

class _DragSortWidgetState<T> extends State<DragSortWidget> {
  List<T> _list = List();
  List<GlobalKey<_DragItemState>> _globalKey = List();

  @override
  void initState() {
    super.initState();
    _list = widget.list;

    setState(() {});
  }


  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (_list.length > widget.max) {
      setState(() {
        _list.removeRange(widget.max - 1, _list.length - 1);
      });
    }
    if (widget.callBackDragSort != null) {
      widget.callBackDragSort.onList(_list);
    }

    ScreenUtil.getInstance().init(context);
    var w = ScreenUtil.getInstance()
        .setWidth((ScreenUtil.getInstance().width - 41)~/3);

    List<dynamic> widgets = _list.asMap().keys.map((index) {
      GlobalKey<_DragItemState> _key = GlobalKey<_DragItemState>();

      _globalKey.add(_key);

      return Container(
        child: DragItem<T>(
          size: w,
          data: _list[index],
          key: _globalKey[index],
          index: index,
          child: widget.dragItemBuilderDelegate,
          call: (newValue, oldValue) {
            print('$newValue  ======= $oldValue  ');
            T temp = _list[newValue];
            _list[newValue] = _list[oldValue];
            _list[oldValue] = temp;

            _globalKey[oldValue].currentState.update(_list[oldValue], oldValue);
            _globalKey[newValue].currentState.update(_list[newValue], newValue);
          },
        ),
      );
    }).toList();

    if (widget.endWidget != null && _list.length < widget.max)
      widgets.add(Container(height: w, width: w, child: widget.endWidget));

    return Container(
      key: GlobalKey(),
      width: double.infinity,
      child: Wrap(
        verticalDirection: VerticalDirection.down,
        spacing: ScreenUtil.getInstance().setWidth(10),
        runSpacing: ScreenUtil.getInstance().setWidth(10),
        children: widgets,
      ),
    );
  }
}

class DragItem<T> extends StatefulWidget {
  final dynamic data;
  final double size;
  final int index;
  final Function call;
  final DragItemBuilderDelegate child;
  final mainChild;

  const DragItem(
      {Key key,
      this.data,
      this.size,
      this.index,
      this.call,
      this.child,
      this.mainChild})
      : super(key: key);

  @override
  _DragItemState createState() => _DragItemState<T>();
}

class _DragItemState<T> extends State<DragItem> {
  T data;
  var index;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    index = widget.index;
    setState(() {});

    print(data);
  }

  update(T data, int index) {
    this.data = data;
    this.index = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var child = widget.child.build(context, index, data);
    var temp = widget.mainChild ??
        <Widget>[
          Positioned(
              top: 5,
              right: 5,
              left: 5,
              bottom: 5,
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xfff2f2f2))),
                  child: child)),
          Positioned(
            top: 0,
            right: 0,
            child: Icon(
              Icons.cancel,
            ),
          )
        ];

    var wid = Container(
      height: widget.size,
      width: widget.size,
      child: Stack(
        fit: StackFit.passthrough,
        children: temp,
      ),
    );

    return LongPressDraggable(
      data: index,
      child: DragTarget(
          onWillAccept: (res) {
            return true; //当Draggable传递过来的dada不是null的时候 决定接收该数据。
          },
          onAccept: (res) {
            widget.call(res, index);
          },
          onLeave: (res) {},
          builder: (context, candidateData, rejectedData) {
            return wid;
          }),
      onDragStarted: () {
        print('start  $index');
      },
      feedback: Card(
        child: Container(
          height: widget.size * 0.9,
          width: widget.size * 0.9,
          child: child,
        ),
      ),
    );
  }
}
