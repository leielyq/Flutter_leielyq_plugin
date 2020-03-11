import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RichEndText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final String tag;

  const RichEndText(this.text, this.textStyle, this.tag, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
        TextSpan(
      children: <InlineSpan>[
        TextSpan(text: text, style: textStyle),
        WidgetSpan(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Color(0xFFFFC600),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Container(
                child: Text(
                  '# $tag',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            alignment: PlaceholderAlignment.middle,
            baseline: TextBaseline.alphabetic,
        ),
      ],
    ));
  }
}
