import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// 自定义 SliverPersistentHeaderDelegate
class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  //按照分析，让子组件尽可能占用布局就OK
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    print("当前：" + shrinkOffset.toString());

    return Stack(
      children: <Widget>[
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          bottom: -shrinkOffset,
          child: SizedBox.expand(child: child),
        )
      ],
    );
  }

//如果传递的这几个参数变化了，那就重写创建
  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }

  @override
  String toString() => '_SliverAppBarDelegate';
}
