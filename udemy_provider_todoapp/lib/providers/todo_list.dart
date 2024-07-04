// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:udemy_provider_todoapp/models/todo_model.dart';

class TodoListState {
  final List<Todo> todos;

  TodoListState({required this.todos});

  factory TodoListState.initialize() {
    return TodoListState(todos: [
      Todo(id: '1', description: '방 청소'),
      Todo(id: '2', description: '설거지'),
      Todo(id: '3', description: '숙제'),
    ]);
  }

  TodoListState copyWith({
    List<Todo>? todos,
  }) {
    return TodoListState(
      todos: todos ?? this.todos,
    );
  }

  @override
  String toString() => 'TodoListState(todos: $todos)';

  @override
  bool operator ==(covariant TodoListState other) {
    if (identical(this, other)) return true;

    return listEquals(other.todos, todos);
  }

  @override
  int get hashCode => todos.hashCode;
}

class TodoList with ChangeNotifier {
  TodoListState _state = TodoListState.initialize();
  TodoListState get state => _state;

  ///새로운 todo 추가
  void addTodo(String newDescription) {
    ///새로 추가된 newDescription만으로 todo 객체 하나 생성 (Todo의 나머지 속성 id, bool은 required 아님)
    final Todo newTodo = Todo(description: newDescription);

    ///기존 todo 리스트와 새로 추가된 todo를 더해서 하나의 배열의 만듦
    final List<Todo> newTodos = [..._state.todos, newTodo];

    ///추가된 todo까지 더해진 todo 리스트를 _state에 할당
    _state = _state.copyWith(todos: newTodos);
    notifyListeners();
  }

  ///기존 todo edit
  ///-> 1) description만 edit되는 경우, 2)isComplted가 edit되는 경우
  ///1) description만 edit되는 경우
  void editDescription(String id, String modifiedDescription) {
    final List<Todo> newTodos = _state.todos.map(
      (Todo element) {
        if (element.id == id) {
          return Todo(
              id: id,
              description: modifiedDescription,
              isCompleted: element.isCompleted);
        }
        return element;
      },
    ).toList();
    _state = _state.copyWith(todos: newTodos);
    notifyListeners();
  }

  ///2)isComplted가 edit되는 경우
  void editIsCompleted(String id, bool modifiedCompleted) {
    final List<Todo> newTodos = _state.todos.map(
      (Todo element) {
        if (element.id == id) {
          return Todo(
              id: id,
              description: element.description,
              isCompleted: modifiedCompleted);
        }
        return element;
      },
    ).toList();
    _state = _state.copyWith(todos: newTodos);
    notifyListeners();
  }

  ///todo 삭제
  void removeTodo(String id) {
    final List<Todo> newTodos =
        _state.todos.where((Todo element) => element.id != id).toList();
    _state = _state.copyWith(todos: newTodos);
    notifyListeners();
  }
}
