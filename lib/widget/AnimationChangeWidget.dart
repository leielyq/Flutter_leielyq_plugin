import 'package:flutter/material.dart';

class AnimationChangeWidget extends StatefulWidget {
  final Widget child;
  final double childWidth;
  final double scale;

  const AnimationChangeWidget(
      {Key key, this.child, this.childWidth, this.scale})
      : super(key: key);

  @override
  _AnimationChangeWidgetState createState() => _AnimationChangeWidgetState();
}

class _AnimationChangeWidgetState extends State<AnimationChangeWidget>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
    animation = Tween(begin: widget.childWidth, end: widget.childWidth * 0.9)
        .animate(controller)
          ..addListener(() {
            setState(() {
              // the state that has changed here is the animation object’s value
            });
          });

  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) {
        print('-------');
        controller.forward();
      },
      onPointerCancel: (e) {
        print('+++++++');
        controller.reverse();
      },
      onPointerUp: (e) {
        print('=========');
        controller.reverse();
      },
      child: Container(
          height: animation?.value * widget.scale,
          width: animation?.value,
          child: widget.child),
    );
  }
}
