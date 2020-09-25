import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/page/counterPage/bloc/CountBloc.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({Key key}) : super(key: key);

  // static final bloc = CounterBloc();

  // static final subscription = bloc.listen((int i) { 
  //   print(i);
  // });
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("count", ),
      ),
      body: BlocBuilder<CounterBloc, int>(
        buildWhen: (pre, cur) {
          print('''
                  $pre -> $cur
                ''');
          return cur != pre;
        },
        builder: (_, count) => Center(
          child: Text("$count"),
        )
      ),
      floatingActionButton: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 200.0),
            child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => context.bloc<CounterBloc>().add(CountEvent.increment),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: const Icon(Icons.remove),
              onPressed: () => context.bloc<CounterBloc>().add(CountEvent.decrement),
            ),
          ),


          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: BlocProvider.value(
              value: BlocProvider.of<CounterBloc>(context),
              child: Text("123"),
            )
          ),
        ],
      ),
    );
  }
}