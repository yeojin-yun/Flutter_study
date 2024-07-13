// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_basic/screens/counter_screen.dart';

class CounterState {
  final int count;
  CounterState({
    required this.count,
  });

  factory CounterState.intialize() {
    return CounterState(count: 0);
  }

  CounterState copyWith({
    int? count,
  }) {
    return CounterState(
      count: count ?? this.count,
    );
  }

  @override
  String toString() => 'CounterState(count: $count)';

  @override
  bool operator ==(covariant CounterState other) {
    if (identical(this, other)) return true;

    return other.count == count;
  }

  @override
  int get hashCode => count.hashCode;
}

class CounterProvider extends StateNotifier<CounterState> {
  CounterProvider() : super(CounterState.intialize());

  void increment() => state = state.copyWith(count: state.count + 1);

  void decrement() => state = state.copyWith(count: state.count - 1);
}
