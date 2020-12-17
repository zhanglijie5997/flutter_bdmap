// import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/components/bdMap.dart';
import 'package:map/router/bloc/routerBloc.dart';

class Index extends StatefulWidget {
  Index({Key key}) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {

  ScrollController _controller = new ScrollController();

  Widget _uiView(BuildContext context, int state) => Container(
        child: Column(
          children: [
            Text("$state"),
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () =>
                    context.bloc<RouterBloc>().add(RouterEvent.change))
          ],
        ),
        width: 200,
        height: 200,
      );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<RouterBloc, int>(
      builder: (context, state) => AMap(), 
      listener: (context, state) {

      }
  );
  // {
  //   return BlocBuilder<RouterBloc, int>(
  //       builder: (_, state) => RepositoryProvider(
  //             create: (_) => IndexBloc(),
  //             child: _uiView(context, state),
  //           ));
  // }
}
