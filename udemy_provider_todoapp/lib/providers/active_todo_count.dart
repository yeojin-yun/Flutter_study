// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:udemy_provider_todoapp/models/todo_model.dart';
import 'package:udemy_provider_todoapp/providers/todo_list.dart';

class ActiveTodoCountState {
  final int activeTodoCount;

  ActiveTodoCountState({required this.activeTodoCount});

  factory ActiveTodoCountState.intialize() {
    return ActiveTodoCountState(activeTodoCount: 0);
  }

  ActiveTodoCountState copyWith({
    int? activeTodoCount,
  }) {
    return ActiveTodoCountState(
      activeTodoCount: activeTodoCount ?? this.activeTodoCount,
    );
  }

  @override
  bool operator ==(covariant ActiveTodoCountState other) {
    if (identical(this, other)) return true;

    return other.activeTodoCount == activeTodoCount;
  }

  @override
  int get hashCode => activeTodoCount.hashCode;

  @override
  String toString() => 'ActiveTodoCount(activeTodoCount: $activeTodoCount)';
}

class ActiveTodoCount with ChangeNotifier {
  late ActiveTodoCountState _state;
  final int initialActiveTodoCount;

  ActiveTodoCount({required this.initialActiveTodoCount}) {
    _state = ActiveTodoCountState(activeTodoCount: initialActiveTodoCount);
  }

  // ActiveTodoCountState _state = ActiveTodoCountState.intialize();
  ActiveTodoCountState get state => _state;

  ///List<Todo>에서 각 항목들의 isCompleted가 true인지 false인지 알아야 하기 때문에 -> TodoList를 가져와야 함
  ///todoList 처음으로 얻을 때, 그 이후 값이 변화가 있을 때마다 호출됨
  void update(TodoList todoList) {
    debugPrint('✅[ActiveTodo - before] ${_state.activeTodoCount}');
    final int newActivieTodoCount = todoList.state.todos
        .where((Todo element) => !element.isCompleted)
        .toList()
        .length;
    _state = _state.copyWith(activeTodoCount: newActivieTodoCount);
    debugPrint('✅[ActiveTodo - after] ${_state.activeTodoCount}');
    notifyListeners();
  }
}
