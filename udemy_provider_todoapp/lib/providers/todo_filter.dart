// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:udemy_provider_todoapp/models/todo_model.dart';

///필터 상태를 변경시키고, 리스닝하는 다른 위젯들에게 알릴 provider
class TodoFilterState {
  final Filter filter;

  TodoFilterState({required this.filter});

  factory TodoFilterState.initialize() {
    return TodoFilterState(filter: Filter.all);
  }

  @override
  String toString() => 'TodoFilter(filter: $filter)';

  @override
  bool operator ==(covariant TodoFilterState other) {
    if (identical(this, other)) return true;

    return other.filter == filter;
  }

  @override
  int get hashCode => filter.hashCode;

  TodoFilterState copyWith({
    Filter? filter,
  }) {
    return TodoFilterState(
      filter: filter ?? this.filter,
    );
  }
}

class TodoFilter with ChangeNotifier {
  TodoFilterState _state = TodoFilterState.initialize();
  TodoFilterState get state => _state;

  void changFilter(Filter newFilter) {
    ///copyWith : 기존 값이 아닌 새로운 값을 만듦
    _state = _state.copyWith(filter: newFilter);
    notifyListeners();
  }
}
