import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:udemy_provider_todoapp_refactor2/providers/providers.dart';

import '../models/todo_model.dart';

class TodoFilterState extends Equatable {
  final Filter filter;
  const TodoFilterState({
    required this.filter,
  });

  factory TodoFilterState.initial() {
    return const TodoFilterState(filter: Filter.all);
  }

  @override
  List<Object> get props => [filter];

  @override
  bool get stringify => true;

  TodoFilterState copyWith({
    Filter? filter,
  }) {
    return TodoFilterState(
      filter: filter ?? this.filter,
    );
  }
}

class TodoFilter extends StateNotifier<TodoFilterState> {
  TodoFilter() : super(TodoFilterState(filter: Filter.all));

  void changeFilter(Filter newFilter) {
    state = state.copyWith(filter: newFilter);
  }
}
