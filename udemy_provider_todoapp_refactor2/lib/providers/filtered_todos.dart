import 'package:equatable/equatable.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:state_notifier/state_notifier.dart';

import '../models/todo_model.dart';
import 'providers.dart';

class FilteredTodosState extends Equatable {
  final List<Todo> filterdTodos;
  const FilteredTodosState({
    required this.filterdTodos,
  });

  factory FilteredTodosState.initial() {
    return const FilteredTodosState(filterdTodos: []);
  }

  @override
  List<Object> get props => [filterdTodos];

  @override
  bool get stringify => true;

  FilteredTodosState copyWith({
    List<Todo>? filterdTodos,
  }) {
    return FilteredTodosState(
      filterdTodos: filterdTodos ?? this.filterdTodos,
    );
  }
}

class FilteredTodos extends StateNotifier<FilteredTodosState>
    with LocatorMixin {
  FilteredTodos() : super(FilteredTodosState.initial());

  @override
  void update(Locator watch) {
    // TODO: implement update
    List<Todo> _filteredTodos;

    switch (watch<TodoFilterState>().filter) {
      case Filter.active:
        _filteredTodos = watch<TodoListState>()
            .todos
            .where((Todo todo) => !todo.completed)
            .toList();
        break;
      case Filter.completed:
        _filteredTodos = watch<TodoListState>()
            .todos
            .where((Todo todo) => todo.completed)
            .toList();
        break;
      case Filter.all:
      default:
        _filteredTodos = watch<TodoListState>().todos;
        break;
    }

    if (watch<TodoSearchState>().searchTerm.isNotEmpty) {
      _filteredTodos = _filteredTodos
          .where((Todo todo) => todo.desc
              .toLowerCase()
              .contains(watch<TodoSearchState>().searchTerm.toLowerCase()))
          .toList();
    }

    state = state.copyWith(filterdTodos: _filteredTodos);
    super.update(watch);
  }
}
