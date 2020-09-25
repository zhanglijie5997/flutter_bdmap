import 'package:flutter_bloc/flutter_bloc.dart';

enum RouterEvent {
  home,
  change,
  cart,
  user
}

class RouterBloc extends Bloc<RouterEvent, int>{
  static int _routerIndex = 0;
  RouterBloc(): super(_routerIndex);
  
  @override
  Stream<int> mapEventToState(RouterEvent event) async*{
    print(state);
    switch (event) {
      case RouterEvent.home:
        _routerIndex = 0;
        yield _routerIndex ;
        break;
      case RouterEvent.change:
        _routerIndex = 1;
        yield _routerIndex;
        break;
      case RouterEvent.cart:
        _routerIndex = 2;
        yield _routerIndex;
        break;
      case RouterEvent.user:
        _routerIndex = 3;
        yield _routerIndex;
        break;
      default:
    }
  }
}