import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class FoldText extends StatefulWidget {
  final String text;
  final int num;
  final TextStyle style;

  const FoldText(
      {Key key, @required this.text, @required this.num, @required this.style})
      : super(key: key);

  @override
  _FoldTextState createState() => _FoldTextState(text);
}

class _FoldTextState extends State<FoldText> {
  final String text;

  _FoldTextState(this.text);

  bool isFold = true;

  @override
  Widget build(BuildContext context) {
    final TapGestureRecognizer _recognizer = new TapGestureRecognizer();

    _recognizer.onTap = () {
      setState(() {
        isFold = !isFold;
      });
    };

    return Material(
      child: Container(
        child:
        RichText(
          text: TextSpan(
              text: text.substring(
                  0, isFold && text.length > widget.num ? widget.num : text
                  .length),
              style: widget.style,
              children: <TextSpan>[
                TextSpan(
                    text: text.length > widget.num?isFold ? '+++' : "---":"",
                    style: TextStyle(color: Colors.redAccent),
                    recognizer: _recognizer),
              ]),
        ),
      ),
    );
  }
}
