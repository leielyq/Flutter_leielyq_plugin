import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomListView extends StatefulWidget {
  final List<dynamic> data;
  final Widget emptyChild;
  final CustomChildBuilderDelegate childBuilderDelegate;
  final Function call;
  final bool isLoadingMore;
  final Widget divider;
  final double angle;

  const CustomListView({Key key,
    this.data,
    this.emptyChild,
    this.childBuilderDelegate,
    this.call,
    this.isLoadingMore,
    this.divider,
    this.angle})
      : super(key: key);

  @override
  _CustomListViewState createState() => _CustomListViewState();
}

abstract class CustomChildBuilderDelegate<T> {
  Widget build(BuildContext context, int index, T data);
}

class _CustomListViewState extends State<CustomListView> {
  @override
  Widget build(BuildContext context) {
    bool isLoading = widget.isLoadingMore ?? false;

    var sliverList = SliverList(

      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          var item;

          if (widget.data == null) {
            item = Container(
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
                    Text('加载中')
                  ],
                ),
              ),
            );
          } else

          if (widget.data.length == 0) {
            item = Center(
              child: widget.emptyChild ?? Text("没有数据"),
            );
          } else

          if (index.isEven) {
            if (index == widget.data.length * 2) {
              if (!isLoading) {
                isLoading = true;
                if (widget.call != null) widget.call();
                item = Offstage(
                    offstage: widget.data.length < 10,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ));
              }else{
                item = Container();
              }

            } else {
              item = widget.childBuilderDelegate.build(
                  context, index.toInt() ~/ 2, widget.data[index.toInt() ~/ 2]);
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
        addAutomaticKeepAlives:false,
        childCount: widget.data != null ? widget.data.length * 2 + 1 : 1,
      ),
    );

    return sliverList;
  }
}
