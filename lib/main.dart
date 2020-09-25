import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/router/bloc/routerBloc.dart';
import 'package:map/router/router.dart';
import 'package:flutter_bmfbase/BaiduMap/bmfmap_base.dart'
    show BMFMapSDK, BMF_COORD_TYPE;
/// Custom [BlocObserver] which observes all bloc and cubit instances.
class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print("事件 -> $event");
    super.onEvent(bloc, event);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    print("改变的值 -> change");
    super.onChange(cubit, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print("修改值后前比较 -> $transition");
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(cubit, error, stackTrace);
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //状态栏透明
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  if(Platform.isIOS) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    BMFMapSDK.setApiKeyAndCoordType('CMXPbMyCz3rxFTlZ9M9EyfMvao3lLxvl', BMF_COORD_TYPE.BD09LL);
  }
  Bloc.observer = SimpleBlocObserver();
  //强制竖屏
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorState = new GlobalKey(); // 全局路由
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (BuildContext context) => ThemeCubit()),
      ],
      
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (_, state) => MaterialApp(
          navigatorKey: navigatorState,
          theme: state,
          home: BlocProvider(
            create: (_) => RouterBloc(),
            child: RouterPage(),
          ),
        )
      ),
    );
  }
}

/// {@template brightness_cubit}
/// A simple [Cubit] which manages the [ThemeData] as its state.
/// {@endtemplate}
class ThemeCubit extends Cubit<ThemeData> {
  /// {@macro brightness_cubit}
  ThemeCubit() : super(_lightTheme);

  static final _baseTheme = ThemeData(
    appBarTheme: AppBarTheme(
      elevation: 0,
      color: Colors.white,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.black,
          fontSize: 24
        )
      )
    ),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.black,
        fontSize: 24
      )
    ),
    iconTheme: IconThemeData(
      color: Colors.black
    ),
    accentIconTheme: IconThemeData(
      color: Colors.grey[300]
    )
  );

  static final _lightTheme = ThemeData(
    appBarTheme: _baseTheme.appBarTheme,
    textTheme: _baseTheme.textTheme,
    iconTheme: _baseTheme.iconTheme,
    accentIconTheme: _baseTheme.accentIconTheme,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
    ),
    brightness: Brightness.light,
  );

  static final _darkTheme = ThemeData(
    appBarTheme: _baseTheme.appBarTheme,
    accentIconTheme: _baseTheme.accentIconTheme,
    textTheme: _baseTheme.textTheme,
    iconTheme: _baseTheme.iconTheme,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.black,
    ),
    brightness: Brightness.dark,
  );

  /// Toggles the current brightness between light and dark.
  void toggleTheme() {
    emit(state.brightness == Brightness.dark ? _lightTheme : _darkTheme);
  }
}
