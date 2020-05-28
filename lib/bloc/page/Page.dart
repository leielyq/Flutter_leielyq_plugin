import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_leielyq_plugin/view/CustomListView.dart';
import 'package:flutter_leielyq_plugin/view/CustomListView2.dart';

import '../BlocProvider.dart';

class Bean<T> {
  bool isLoading;
  List<T> list;

  Bean(arg0, arg1) {
    isLoading = arg0;

    list = arg1 == null ? List() : arg1;
  }
}

abstract class PageBaseBloc<T> extends BaseBloc {
  int _count = 1;

  int get count => _count;

  T _bean;

  T get bean => _bean;

  // stream
  StreamController<T> countController = StreamController<T>.broadcast();

  Stream<T> get stream => countController.stream; // 用于 StreamBuilder 的 stream

  PageBaseBloc() {
    countController.stream.listen((item) {
      _bean = item;
      _count++;
    });
  }

  void dispatch(int page, T bean);

  @override
  void dispose() {
    countController.close();
  }
}

abstract class PageBloc extends PageBaseBloc<Bean> {
  PageBloc() {

  }

  void getData() {
    Bean bean = Bean(false, null);
    dispatch(1, bean);
  }

  addAll(List list, Bean bean) {
    if (list == null || list.length < 10) {
      bean.isLoading = true;
    }
    bean.list.addAll(list);
    countController.sink.add(bean);
  }

  void dispatch(int page, Bean bean);
}

class PageList<T extends PageBloc> extends StatelessWidget {
  final CustomChildBuilderDelegate2 child;
  final Widget divider;
  final Widget endWidget;
  final double angle;

  const PageList(this.child, {Key key, this.divider,this.angle,this.endWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 获取注册的 bloc，必须先注册，再去查找
    final T _bloc = BlocProvider.of<T>(context);

    return StreamBuilder<Bean>(
        stream: _bloc.stream,
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot<Bean> snapshot) {
          return CustomListView2(
            loadingMore: () {
              _bloc.dispatch(_bloc.count, snapshot.data);
            },
            disableLoadingMore: snapshot?.data?.isLoading ?? false,
            data: snapshot.data == null ? null : List.from(snapshot.data.list),
            childBuilderDelegate: child,
            angle: angle,
            divider: divider,
            emptyChild: endWidget,
          );
        });
  }
}

class PageListRoot<T extends BaseBloc> extends StatefulWidget {
  final T bloc; //you need build your PageBloc!
  final PageList<PageBloc> blocWidget; //you need build your PageList!

  const PageListRoot({Key key, this.bloc, this.blocWidget}) : super(key: key);

  @override
  _PageListRootState<T> createState() => _PageListRootState<T>();
}

class _PageListRootState<T extends BaseBloc> extends State<PageListRoot> {
  @override
  Widget build(BuildContext context) {
    T item = widget.bloc;
    return BlocProvider(child: widget.blocWidget, bloc: item);
  }
}
