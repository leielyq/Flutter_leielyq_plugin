import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Colors {

  const Colors();

  static const Color loginGradientStart = const Color(0xFFfbab66);
  static const Color loginGradientEnd = const Color(0xFFf7418c);
  static const Color mainBtn = const Color(0xFF03A9F4);
  static const Color black = const Color(0xFF000000);
  static const Color bgColor = const Color(0xFFf2f2f2);
  static const Color textHint = const Color(0xFFcccccc);
  static const Color textPoint = const Color(0xFF808080);

  static const TextStyle hintStyle = const TextStyle(color: textHint,fontSize: 14);
  static const TextStyle pointStyle = const TextStyle(color: textPoint,fontSize: 16);
  static const TextStyle chooseStyle = const TextStyle(color: textPoint,fontSize: 16);
  static const TextStyle nameStyle = const TextStyle(color: textPoint,fontSize: 10);
  static const TextStyle titleStyle = const TextStyle(color: black,fontSize: 16);
  static const TextStyle contextStyle = const TextStyle(color: black,fontSize: 14);


  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class Device{
  const Device();



}