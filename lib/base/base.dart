export 'package:extended_image/extended_image.dart';
export 'package:flutter_leielyq_plugin/view/MySliverAppBar.dart';

import 'package:flutter/widgets.dart';
abstract class BaseState<T extends StatefulWidget> extends State {
  @override
  void initState() {
    super.initState();

    init();
  }

  init() {

  }
}
