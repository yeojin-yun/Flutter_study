// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:udemy_provider_todoapp/models/todo_model.dart';
import 'package:udemy_provider_todoapp/providers/todo_filter.dart';
import 'package:udemy_provider_todoapp/providers/todo_search.dart';
import 'package:udemy_provider_todoapp/providers/todo_list.dart';

class FilteredTodosState {
  final List<Todo> filteredTodos;

  FilteredTodosState({required this.filteredTodos});

  factory FilteredTodosState.initialize() {
    return FilteredTodosState(filteredTodos: []);
  }

  FilteredTodosState copyWith({
    List<Todo>? FilteredTodos,
  }) {
    return FilteredTodosState(
      filteredTodos: FilteredTodos ?? this.filteredTodos,
    );
  }

  @override
  String toString() => 'FilteredTodosState(FilteredTodos: $filteredTodos)';

  @override
  bool operator ==(covariant FilteredTodosState other) {
    if (identical(this, other)) return true;

    return listEquals(other.filteredTodos, filteredTodos);
  }

  @override
  int get hashCode => filteredTodos.hashCode;
}

class FilteredTodos with ChangeNotifier {
  FilteredTodosState _state = FilteredTodosState.initialize();
  FilteredTodosState get state => _state;

  ///필요한 값 : todo리스트, 현재 filter, 사용자의 검색어
  ///의존값을 처음으로 얻을 때, 그 이후 의존값이 변경될 때마다 여러번 호출됨 -> []로 설정했던 초기값은 금방 변경됨
  void update(TodoFilter todoFilter, TodoSearch todoSearch, TodoList todoList) {
    List<Todo> _filteredTodos;

    ///1. 필터에 따라 todo 리스트 뽑아내기
    switch (todoFilter.state.filter) {
      case Filter.active:
        _filteredTodos = todoList.state.todos
            .where((Todo element) => !element.isCompleted)
            .toList();
        break;
      case Filter.completed:
        _filteredTodos = todoList.state.todos
            .where((Todo element) => element.isCompleted)
            .toList();
        break;
      case Filter.all:
        _filteredTodos = todoList.state.todos;
    }

    ///2. 검색어 필터
    if (todoSearch.state.searchTerm.isNotEmpty) {
      _filteredTodos = _filteredTodos
          .where((Todo element) =>
              element.description.contains(todoSearch.state.searchTerm))
          .toList();
    }

    _state = _state.copyWith(FilteredTodos: _filteredTodos);
    notifyListeners();
  }
}
