# udemy_provider_todoapp_refactor
- 기존에 ChangeNotifierProvider + ChangeNotifierProxyProvider를 사용해서 만든 앱을 ChangeNotifierProvider + ProxyProvider로 리팩토링

**그러나 그 Provider가 단독 state가 없고 단순히 다른 Provider의 의존하는 경우에는 ProxyProvider로 관리가 가능 (공식문서에서도 ChangeNotifierProxyProvider보다는 ProxyProvider을 사용할 것을 권장)**

----------

## Provider

### ActiveTodoCount

-   일반 클래스로 전환 후 변수로 받은 TodoList 타입의 객체 todoList의 갯수 계산만 받아옴

```dart
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

class ActiveTodoCount {
  final TodoList todoList;

  ActiveTodoCount({required this.todoList});

  //todo List 중에서 완료가 안된 것들만 가져옴
  ActiveTodoCountState get state => ActiveTodoCountState(
      activeTodoCount: todoList.state.todos
          .where(
            (element) => !element.isCompleted,
          )
          .toList()
          .length);
}


```

### FilteredTodo

-   일반 클래스로 전환
-   FilteredTodo 계산에 필요한 TodoList, TodoFilter, TodoSearch를 변수로 받고 생성자 만들기
-   getter 사용해 Filtered가 된 Todo 리스트를 받을 수 있도록

```dart
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

class FilteredTodos {
  final TodoFilter todoFilter;
  final TodoList todoList;
  final TodoSearch todoSearch;

  FilteredTodos(
      {required this.todoFilter,
      required this.todoList,
      required this.todoSearch});

  ///필요한 값 : todo리스트, 현재 filter, 사용자의 검색어
  ///의존값을 처음으로 얻을 때, 그 이후 의존값이 변경될 때마다 여러번 호출됨 -> []로 설정했던 초기값은 금방 변경됨
  FilteredTodosState get state {
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
    return FilteredTodosState(filteredTodos: _filteredTodos);
  }
}


```

### 선언부

-   `update`만 사용하여 의존하는 값들이 바뀔 때마다 객체를 생성하도록 함

```dart
providers: [
  ...
  ProxyProvider<TodoList, ActiveTodoCount>(
    update: (BuildContext context, TodoList todo, ActiveTodoCount? _) =>
      ActiveTodoCount(todoList: todo),
    ),
  ProxyProvider3<TodoList, TodoSearch, TodoFilter, FilteredTodos>(
    update: (BuildContext context,
      TodoList todoList,
      TodoSearch todoSearch,
      TodoFilter todoFilter,
      FilteredTodos? _) =>
        FilteredTodos(
          todoFilter: todoFilter,
          todoList: todoList,
          todoSearch: todoSearch),
  )
],

```

## UI

-   각 클래스에서 getter로 state 변수를 만들었기 때문에 아래처럼 사용 가능

```dart
Text(
  '${context.watch<ActiveTodoCount>().state.activeTodoCount} items left'),

```

```dart
final todos = context.watch<FilteredTodos>().state.filteredTodos;

```
