import 'package:flutter_bloc/flutter_bloc.dart';

enum IndexEvent {
  change,
}

class IndexBloc extends Bloc<IndexEvent, Map<String, dynamic>> {
  static Map<String, dynamic> _result = { 'a' : 1};
  IndexBloc(): super(_result);
  @override
  Stream<Map<String, dynamic>> mapEventToState(IndexEvent event) async*{

  }
}

