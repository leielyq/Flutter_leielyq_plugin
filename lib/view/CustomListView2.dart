import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomListView2 extends StatefulWidget {
  final List<dynamic> data; //和主数据相关
  final Widget emptyChild; //空
  final CustomChildBuilderDelegate2 childBuilderDelegate; //要显示的数据
  final Function loadingMore; //开启加载更多
  final bool disableLoadingMore; //是否显示加载更多
  final Widget endWidget; //末尾widget
  final Widget loadingWidget; //加载widget
  final Widget divider; //分割
  final double angle; //显示角度
  final List data2; //存放额外数据
  final List<Widget> header;

  const CustomListView2(
      {Key key,
        this.data,
        this.emptyChild,
        this.childBuilderDelegate,
        this.loadingMore,
        this.disableLoadingMore = false,
        this.divider,
        this.angle,
        this.endWidget,
        this.loadingWidget,
        this.data2, this.header=const []})
      : super(key: key);

  @override
  CustomListView2State createState() => CustomListView2State();
}

abstract class CustomChildBuilderDelegate2<T> {
  Widget build(BuildContext context, int index, T data, List data2);
}

class CustomListView2State extends State<CustomListView2> {
  @override
  Widget build(BuildContext context) {
    bool disableLoadingMore = widget.disableLoadingMore ?? false;

    var sliverList = SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          var item;
          if (widget.data == null) {
            item = widget.loadingWidget ??
                Container(
                  color: Colors.white12,
                  height: 200,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                strokeWidth: 4.0,
                                backgroundColor: Colors.blue,
                                // value: 0.2,
                                valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
          } else if (widget.data.length == 0) {
            item = Center(
              child: widget.emptyChild ?? Text(" - No Data - "),
            );
          } else  if(widget.header.length>0&&index.toInt() <widget.header.length){
            item = widget.header[index];
          }else if ((index+widget.header.length).isEven) {
            if (index == widget.data.length * 2+widget.header.length) {
              if (!disableLoadingMore) {
                disableLoadingMore = true;
                if (widget.loadingMore != null) widget.loadingMore();
                item = Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                item = widget.endWidget ??
                    Center(
                      child: Text(' - End - '),
                    );
              }
            } else {
              print((index.toInt()-(widget.header.length)) ~/ 2);
              item = widget.childBuilderDelegate.build(
                  context,
                  index.toInt() ~/ 2,
                  widget.data[(index.toInt()-(widget.header.length)) ~/ 2],
                  widget.data2);
            }
          } else {
            item = widget.divider ??
                Container(
                  color: Colors.white12,
                  height: 20,
                );
          }
          return Transform.rotate(angle: widget.angle ?? 0, child: item);
        },
        semanticIndexCallback: (Widget widget, int localIndex) {
          if (localIndex.isEven) {
            return localIndex ~/ 2;
          }
          return null;
        },
        childCount: widget.data != null ? (widget.data.length) * 2 + 1+widget.header.length : 1,
      ),
    );

    return sliverList;
  }
}
