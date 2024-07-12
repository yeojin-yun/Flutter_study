# udemy_provider_todoapp_refactor2
> 기존에 만들었던 udemy_provider_todoapp을 StateNotifier&StateNotifierProvider를 이용해서 refactor했음

## StateNotifier & StateNotifierProvider 정리
**1. StateNotifier<T>를 extends 하기**
```Dart
class MyClass extends StateNotifier<TodoListState> {}
```
**2. super를 호출해야 함**
- super의 인자로는 state의 초기값을 부여하면 됨
```Dart
class MyClass extends StateNotifier<TodoListState> {
    MyClass() : super(TodoListState.initialize());
}
```
**3. state를 선언하지 않아도 접근이 가능**
- 그냥 `state.`로 접근이 가능

**4. notifyListener();를 호출하지 않아도 됨**
- 알아서 `notifyListener()`이 작동함

**5. LocatorMixin을 mixin하면, watch를 통해 다른 상태들에도 접근 가능**
```Dart
class ActiveTodoCount extends StateNotifier<ActiveTodoCountState>
    with LocatorMixin {

  ActiveTodoCount() : super(ActiveTodoCountState.initial());

  @override
  void update(Locator watch) {
    // TODO: implement update
    super.update(watch);
  }
}
```
---
## `TodoList`
```Dart
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:udemy_provider_todoapp_refactor2/providers/providers.dart';

import '../models/todo_model.dart';

class TodoListState extends Equatable {
  final List<Todo> todos;
  const TodoListState({
    required this.todos,
  });

  factory TodoListState.initial() {
    return TodoListState(todos: [
      Todo(id: '1', desc: 'Clean the room'),
      Todo(id: '2', desc: 'Wash the dish'),
      Todo(id: '3', desc: 'Do homework'),
    ]);
  }

  @override
  List<Object> get props => [todos];

  @override
  bool get stringify => true;

  TodoListState copyWith({
    List<Todo>? todos,
  }) {
    return TodoListState(
      todos: todos ?? this.todos,
    );
  }
}

class TodoList extends StateNotifier<TodoListState> {
  TodoList() : super(TodoListState.initial());

  void addTodo(String todoDesc) {
    final newTodo = Todo(desc: todoDesc);
    final newTodos = [...state.todos, newTodo];

    state = state.copyWith(todos: newTodos);
    print(state);
  }

  void editTodo(String id, String todoDesc) {
    final newTodos = state.todos.map((Todo todo) {
      if (todo.id == id) {
        return Todo(
          id: id,
          desc: todoDesc,
          completed: todo.completed,
        );
      }
      return todo;
    }).toList();

    state = state.copyWith(todos: newTodos);
  }

  void toggleTodo(String id) {
    final newTodos = state.todos.map((Todo todo) {
      if (todo.id == id) {
        return Todo(
          id: id,
          desc: todo.desc,
          completed: !todo.completed,
        );
      }
      return todo;
    }).toList();

    state = state.copyWith(todos: newTodos);
  }

  void removeTodo(Todo todo) {
    final newTodos = state.todos.where((Todo t) => t.id != todo.id).toList();

    state = state.copyWith(todos: newTodos);
  }
}

```
---
## `TodoFilter`
```Dart
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

```
---
## `TodoSearch`
```Dart
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:udemy_provider_todoapp_refactor2/providers/providers.dart';

class TodoSearchState extends Equatable {
  final String searchTerm;
  const TodoSearchState({
    required this.searchTerm,
  });

  factory TodoSearchState.initial() {
    return const TodoSearchState(searchTerm: '');
  }

  @override
  List<Object> get props => [searchTerm];

  @override
  bool get stringify => true;

  TodoSearchState copyWith({
    String? searchTerm,
  }) {
    return TodoSearchState(
      searchTerm: searchTerm ?? this.searchTerm,
    );
  }
}

class TodoSearch extends StateNotifier<TodoSearchState> {
  TodoSearch() : super(TodoSearchState.initial());

  void setSearchTerm(String newSearchTerm) {
    state = state.copyWith(searchTerm: newSearchTerm);
  }
}

```
---
## `ActiveTodoCount`
```Dart
import 'package:equatable/equatable.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:state_notifier/state_notifier.dart';

import '../models/todo_model.dart';
import 'providers.dart';

class ActiveTodoCountState extends Equatable {
  final int activeTodoCount;
  const ActiveTodoCountState({
    required this.activeTodoCount,
  });

  factory ActiveTodoCountState.initial() {
    return const ActiveTodoCountState(activeTodoCount: 0);
  }

  @override
  List<Object> get props => [activeTodoCount];

  @override
  bool get stringify => true;

  ActiveTodoCountState copyWith({
    int? activeTodoCount,
  }) {
    return ActiveTodoCountState(
      activeTodoCount: activeTodoCount ?? this.activeTodoCount,
    );
  }
}

class ActiveTodoCount extends StateNotifier<ActiveTodoCountState>
    with LocatorMixin {
  ActiveTodoCount() : super(ActiveTodoCountState.initial());

  @override
  void update(Locator watch) {
    // TODO: implement update
    final List<Todo> todos = watch<TodoListState>().todos;
    final int activeCount =
        todos.where((element) => !element.completed).toList().length;
    state = state.copyWith(activeTodoCount: activeCount);
    super.update(watch);
  }
}
```
---
## `FilteredTodo`
```Dart
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
```
---
## Provider 선언
```Dart
    return MultiProvider(
      providers: [
        StateNotifierProvider<TodoList, TodoListState>(
          create: (context) => TodoList(),
        ),
        StateNotifierProvider<TodoFilter, TodoFilterState>(
          create: (context) => TodoFilter(),
        ),
        StateNotifierProvider<TodoSearch, TodoSearchState>(
          create: (context) => TodoSearch(),
        ),
        StateNotifierProvider<ActiveTodoCount, ActiveTodoCountState>(
          create: (context) => ActiveTodoCount(),
        ),
        StateNotifierProvider<FilteredTodos, FilteredTodosState>(
          create: (context) => FilteredTodos(),
        ),
      ],
    child: ...
    )
```
---
## 위젯 반영
- read할 때는 평소랑 동일하게 사용
```Dart
context.read<TodoList>().editTodo(...);
context.read<TodoList>().toggleTodo(widget.todo.id);
context.read<TodoList>().removeTodo(todos[index]);
```
- watch는 바로 state에 접근해서 사용하면 됨
- 예전처럼 `context.watch<TodoList>().state.filteredTodos`로 접근하지 않아도 됨. (state가 제공되기 때문에)
```Dart
final todos = context.watch<FilteredTodosState>().filterdTodos;
context.watch<ActiveTodoCountState>().activeTodoCount;
final currentFilter = context.watch<TodoFilterState>().filter;
```