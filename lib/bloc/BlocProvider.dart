import 'package:flutter/widgets.dart';

abstract class BaseBloc {
  void dispose(); // 该方法用于及时销毁资源
}

class BlocProvider<T extends BaseBloc> extends StatefulWidget {
  final Widget child; // 这个 `widget` 在 stream 接收到通知的时候刷新
  final T bloc;

  BlocProvider({Key key, @required this.child, @required this.bloc})
      : super(key: key);

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  // 该方法用于返回 Bloc 实例
  static T of<T extends BaseBloc>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>(); // 获取当前 Bloc 的类型
    // 通过类型获取相应的 Provider，再通过 Provider 获取 bloc 实例
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T> extends State<BlocProvider<BaseBloc>> {
  @override
  void dispose() {
    widget.bloc.dispose(); // 及时销毁资源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}


//保持组件不刷新
class KeepAliveFutureBuilder<T> extends StatefulWidget {
  final Future<T> future;
  final AsyncWidgetBuilder<T> builder;

  KeepAliveFutureBuilder({this.future, this.builder});

  @override
  _KeepAliveFutureBuilderState<T> createState() =>
      _KeepAliveFutureBuilderState<T>();
}

class _KeepAliveFutureBuilderState<T> extends State<KeepAliveFutureBuilder>
    with AutomaticKeepAliveClientMixin {
  Future<T> future;

  @override
  void initState() {
    future = widget.future;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<T>(
      future: future,
      builder: widget.builder,
    );
  }

  @override
  void didUpdateWidget(KeepAliveFutureBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  bool get wantKeepAlive => true;
}
