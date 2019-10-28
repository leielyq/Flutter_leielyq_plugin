import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomListView extends StatefulWidget {
  final List<dynamic> data;
  final Widget emptyChild;
  final CustomChildBuilderDelegate childBuilderDelegate;

  const CustomListView(
      {Key key, this.data, this.emptyChild, this.childBuilderDelegate})
      : super(key: key);

  @override
  _CustomListViewState createState() => _CustomListViewState();
}

abstract class CustomChildBuilderDelegate {
  Widget build(BuildContext context, int index, dynamic data);
}

class _CustomListViewState extends State<CustomListView> {
  @override
  Widget build(BuildContext context) {
    var sliverList = SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          if (widget.data.length != 0) {
            if (index.isEven) {
              if (index == widget.data.length * 2) {
                return Offstage(
                    offstage: widget.data.length < 10,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ));
              } else {
                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: widget.childBuilderDelegate.build(context,
                      index.toInt() ~/ 2, widget.data[index.toInt() ~/ 2]),
                );
              }
            }
            return Container(
              color: Colors.white12,
              height: 20,
            );
          } else {
            return Center(
              child: Text("No Data,woo!"),
            );
          }


        },
        semanticIndexCallback: (Widget widget, int localIndex) {
          if (localIndex.isEven) {
            return localIndex ~/ 2;
          }
          return null;
        },
        childCount: widget.data != null ? widget.data.length * 2 + 1 : 0,
      ),
    );

    return sliverList;
  }
}
