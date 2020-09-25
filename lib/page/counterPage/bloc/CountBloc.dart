import 'package:flutter_bloc/flutter_bloc.dart';

enum CountEvent {
  increment,
  decrement
}

class CounterBloc extends Bloc<CountEvent, int>{
  CounterBloc(): super(0);

  @override
  Stream<int> mapEventToState(CountEvent event) async* {
    switch (event) {
      case CountEvent.decrement:
        yield state - 1;
        break;
      case CountEvent.increment:
        yield state + 1;
        break;
      default:
        addError(Exception('unsupported event'));
    }
  }
}