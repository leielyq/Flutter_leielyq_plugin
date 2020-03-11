import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyScanView extends StatefulWidget {
  @override
  _MyScanViewState createState() => _MyScanViewState();
}

class _MyScanViewState extends State<MyScanView> with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation<int> animation;
  @override
  void initState() {
    super.initState();
    controller =  AnimationController(
        duration: const Duration(milliseconds: 10000), vsync: this);
    animation =  IntTween(begin: 0, end: 300).animate(controller);
    controller.forward();

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    animation.addListener((){
      setState(() {

      });
    });
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScanView(animation: animation,);
  }
}

class AnimatedScanView extends AnimatedWidget{

  AnimatedScanView({Key key, Animation<int> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<int> animation = listenable;
    return CustomPaint(
      painter: ScanView(animation.value),
      size: Size(double.infinity, double.infinity),
    );
  }

}


class ScanView extends CustomPainter {
  Paint mPaint;

  int height;

  ScanView(int height) {
    // 初始化画笔
    mPaint = Paint();
    mPaint.color = Colors.amber;
    // 设置抗锯齿
    mPaint.isAntiAlias = true;
    // 样式为描边
    mPaint.style = PaintingStyle.fill;
    mPaint.strokeWidth = 10;

    this.height = height;


  }

  @override
  void paint(Canvas canvas, Size size) {

    var paintBG = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill //填充
      ..color = Color(0x55000000); //背景为纸黄色

    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.green
      ..strokeWidth = 1.0;

    Rect rect = Rect.fromCircle(center: Offset(size.width/2,size.height/2), radius: 150.0);
    Rect rect1 = Rect.fromLTRB(0, 0, size.width, rect.top);
    Rect rect2 = Rect.fromLTRB(0, rect.bottom, size.width, size.height);
    Rect rect3 = Rect.fromLTRB(0, rect.top, rect.left, rect.bottom);
    Rect rect4 = Rect.fromLTRB(rect.right, rect.top, size.width, rect.bottom);
    canvas.drawRect(rect1, paintBG);
    canvas.drawRect(rect2, paintBG);
    canvas.drawRect(rect3, paintBG);
    canvas.drawRect(rect4, paintBG);
    canvas.drawRect(rect, paint);
    canvas.save();

    canvas.restore();

    canvas.drawLine(Offset(rect.left+10, rect.top+height), Offset(rect.right-10, rect.top+height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }


  Color randomARGB() {
    Random random = Random();
    return Color.fromARGB(
        125, random.nextInt(255), random.nextInt(255), random.nextInt(255));
  }

  Color randomRGB() {
    Random random = Random();
    return Color.fromARGB(
        255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
  }
}
