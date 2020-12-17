import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/components/bdMap.dart';
import 'package:map/page/index/index.dart';
import 'package:map/router/bloc/routerBloc.dart';

class RouterView extends StatefulWidget {
  RouterView({Key key}) : super(key: key);

  @override
  _RouterViewState createState() => _RouterViewState();
}

class _RouterViewState extends State<RouterView> {
  PageController _pageController;
  // 路由
  List<Widget> _router ;

  //滑动的页面
  PageView _viewPager;

  //初始化pageView
  void _initViewPager(){
    _viewPager = PageView(
      children: _router,
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      onPageChanged: (index) {
        // context.bloc<RouterBloc>().add(inde)
      },
    );
  }

  @override
  void initState() {
    _router = [Index(), Index(), Index(), Index()];
    _pageController = PageController(initialPage: 0, keepPage: true);
    super.initState();
    _initViewPager();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RouterBloc, int>(builder: (BuildContext _, state) => Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: AMap(),
    )); 
  }
}