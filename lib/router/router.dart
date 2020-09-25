import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/router/bloc/routerBloc.dart';
import 'package:map/router/view/routerView.dart';

class RouterPage extends StatelessWidget {
  const RouterPage({Key key}) : super(key: key);
  static List<BottomNavigationBarItem> _routerList = [
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")),
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")),
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")),
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RouterBloc, int>(builder: (_, state) => Scaffold(
      body: RouterView(), 
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int i) {
          switch (i) {
            case 0:
              context.bloc<RouterBloc>().add(RouterEvent.home);
              break;
            case 1:
              context.bloc<RouterBloc>().add(RouterEvent.change);
              break;
            case 2:
              context.bloc<RouterBloc>().add(RouterEvent.cart);
              break;
            case 3:
              context.bloc<RouterBloc>().add(RouterEvent.user);
              break;
            default:
          }
          
        },
        currentIndex: state,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: Theme.of(context).iconTheme,
        unselectedIconTheme: Theme.of(context).accentIconTheme,
        items: _routerList,
      ),     
    ));
  }
}