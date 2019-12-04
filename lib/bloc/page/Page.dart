import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_leielyq_plugin/view/CustomListView.dart';

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
    getData();
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

  /*@override
  void dispatch(int page, Bean<HotContentEntity> bean) {
    NetUtils().loadHotContentList((res) {
      List<HotContentEntity> list = List();

      if (res != null) {
        for (int i = 0; i < res.length; i++) {
          var item = res[i];
          list.add(HotContentEntity.fromJson(item));
        }
      }
      addAll(list, bean);
    }, id, page, type);
  }*/
  void dispatch(int page, Bean bean);
}

class PageList<T extends PageBloc> extends StatelessWidget {
  final CustomChildBuilderDelegate child;
  final Widget divider;

  const PageList(this.child, {Key key, this.divider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 获取注册的 bloc，必须先注册，再去查找
    final T _bloc = BlocProvider.of<T>(context);

    return StreamBuilder<Bean>(
        stream: _bloc.stream,
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot<Bean> snapshot) {
          return CustomListView(
            call: () {
              _bloc.dispatch(_bloc.count, snapshot.data);
            },
            isLoadingMore: snapshot?.data?.isLoading ?? false,
            data: snapshot.data == null ? null : snapshot.data.list,
            childBuilderDelegate: child,
            divider: divider,
          );
        });
  }
}

class PageListRoot<T extends BaseBloc> extends StatefulWidget {
  final T bloc; //you need build your PageBloc!
  final PageList blocWidget; //you need build your PageList!

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
