# udemy_provider_todoapp
```Plain Text
📍 tip
✔︎ `equatable` 패키지 추가 → 이렇게 하면 `==`와 `human readable`한 코드를 만들 수 있음
✔︎ 모든 모델에 equatable 패키지와 toString(), copyWith()를 적용하고 시작
```
![Untitled](todoApp%20b7eaf33b541f420a97835dc5462d13fd/Untitled.png)

# Package

```yaml
dependencies:
  cupertino_icons: ^1.0.6
  equatable: ^2.0.5
  flutter:
    sdk: flutter
  provider: ^6.1.2
  uuid: ^4.4.0
```

# Model

```dart
//filter에 사용될 enum
enum Filter { all, active, completed }

// 가장 골조가 되는 Todo의 구조

Uuid uuid = Uuid();
class Todo {
  final String id;
  final String description;
  final bool isCompleted;

  // 새로운 todo를 만들 때는 새로운 id(uuid) 사용
  // 기존 todo를 수정할 때는 기존 id(uuid) 사용
  Todo({String? id, required this.description, this.isCompleted = false})
      : id = id ?? uuid.v4();

  @override
  String toString() =>
      'Todo(id: $id, description: $description, isCompleted: $isCompleted)';

  ///equatable
  @override
  bool operator ==(covariant Todo other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.description == description &&
        other.isCompleted == isCompleted;
  }

  ///human readable한 형태로 변경하기 위해
  @override
  int get hashCode => id.hashCode ^ description.hashCode ^ isCompleted.hashCode;
}
```

# Provider
```Plain Text
1. 상태를 위한 클래스를 만들고, 상태의 생성자 만들기
2. 만든 상태 클래스를 기반으로 ChageNotifierProvider 클래스 만들기
3. ChageNotifierProvider 클래스에서 상태의 객체를 생성하고, getter 만들기
4. 상태를 바꾸는 함수들 만들기
    - 상태의 객체를 수정하는 함수들
    - 상태의 객체가 수정된 뒤 다시 상태 객체에 부여하기 (copyWith 사용하여)
    - notifiyListener()를 이용해서 구독자들에게 상태 변화 알리기
```

## TodoList

```dart
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:udemy_provider_todoapp/models/todo_model.dart';

class TodoListState {
  final List<Todo> todos;

  TodoListState({required this.todos});

  //별도의 생성자
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
    debugPrint('✅[TodoList - addTodo] $_state');
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

  ///체크박스 토글
  void toggleTodo(String id) {
    final newTodos = _state.todos.map(
      (Todo element) {
        if (element.id == id) {
          return Todo(
              id: id,
              description: element.description,
              isCompleted: !element.isCompleted);
        }
        return element;
      },
    ).toList();
    _state = _state.copyWith(todos: newTodos);
    debugPrint('✅[TodoList - toggleTodo] $_state');
    notifyListeners();
  }

  ///todo 삭제
  void removeTodo(String id) {
    final List<Todo> newTodos =
        _state.todos.where((Todo element) => element.id != id).toList();
    _state = _state.copyWith(todos: newTodos);
    debugPrint('✅[TodoList - removeTodo] $_state');
    notifyListeners();
  }
}

```

## TodoSearch

- 여기서는 검색 단어가 상태가 됨 → 단어 하나를 상태로 만드는 걸 오바스럽다고 생각할 수도 있지만, 나중에 앱이 커질수록 이렇게 만드는 게 앱 파악에 도움이 됨. 여러 개발자와 일할 때도 훨 좋음

```dart
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TodoSearchState {
  final String searchTerm;

  TodoSearchState({required this.searchTerm});

  //별도의 생성자
  factory TodoSearchState.initialize() {
    return TodoSearchState(searchTerm: "");
  }

  TodoSearchState copyWith({
    String? searchTerm,
  }) {
    return TodoSearchState(
      searchTerm: searchTerm ?? this.searchTerm,
    );
  }

  @override
  String toString() => 'TodoSearchState(searchTerm: $searchTerm)';

  @override
  bool operator ==(covariant TodoSearchState other) {
    if (identical(this, other)) return true;

    return other.searchTerm == searchTerm;
  }

  @override
  int get hashCode => searchTerm.hashCode;
}

//Provider
class TodoSearch with ChangeNotifier {
  TodoSearchState _state = TodoSearchState.initialize();
  TodoSearchState get state => _state;

  void setSearchTerm(String newSearchTerm) {
    _state = _state.copyWith(searchTerm: newSearchTerm);
    notifyListeners();
  }
}

```

## TodoFilter

- 여기서 상태는 필터임 ([Model](https://www.notion.so/todoApp-b7eaf33b541f420a97835dc5462d13fd?pvs=21)에서 만들었던 enum으로 상태를 관리)

```dart
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
    debugPrint('✅[TodoFilter - changFilter] $_state');
    notifyListeners();
  }
}

```

## ActiveTodoCount - `Computed State`

- 필터 상태에 따라 몇 개의 할 일이 남았는지 표시할 때, 사용하게 될 프로바이더
- 현재 할 일 중 `isCompleted`가 `false`인 할 일의 갯수가 필요 → `TodoList`가 필요 ⇒ `TodoList`에 의존적인 프로바이더 ⇒ ProxyProvider? 라는 생각이 필요
- 여기서의 상태는 남은 할 일의 갯수임 (계속해서 갯수가 바뀔 것이므로)

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

class ActivieTodoCount with ChangeNotifier {
  ActiveTodoCountState _state = ActiveTodoCountState.intialize();
  ActiveTodoCountState get state => _state;

  ///List<Todo>에서 각 항목들의 isCompleted가 true인지 false인지 알아야 하기 때문에 -> TodoList를 가져와야 함
  ///todoList 처음으로 얻을 때, 그 이후 값이 변화가 있을 때마다 호출됨
  void update(TodoList todoList) {
    debugPrint('✅[Active Todo - update 1] ${todoList.state}');
    final int newActivieTodoCount = todoList.state.todos
        .where((Todo element) => !element.isCompleted)
        .toList()
        .length;
    _state = _state.copyWith(activeTodoCount: newActivieTodoCount);
    debugPrint('✅[Active Todo - update 2] $_state');
    notifyListeners();
  }
}

```

## FilteredTodo - `Computed State`

- `Filter` 값에 따라 보여주게 될 상태 (유저가 `filter`에서 `all`/`active`/`completed`를 누르게 되는데 그 때마다 아래 보여줄 할 일 리스트)
- 이 리스트를 현재 `TodoList`와 `TodoFilter`, `TodoSearch`에 전부 의존하는 값임
    - 일단 기본적으로 전체 리스트가 필요하기 때문에 → `TodoList`
    - 어떤 필터가 적용된 상태인지 필요 → `TodoFilter`
    - 어떤 단어가 검색된 상태인지 필요 → `TodoSearch`

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

```

## Provider 선언

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udemy_provider_todoapp/pages/todos_pages.dart';
import 'package:udemy_provider_todoapp/providers/providers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TodoList(),
        ),
        ChangeNotifierProvider(
          create: (context) => TodoFilter(),
        ),
        ChangeNotifierProvider(
          create: (context) => TodoSearch(),
        ),
        //의존적인 프로바이더 -> ChangeNotifierProxyProvider
        ChangeNotifierProxyProvider<TodoList, ActiveTodoCount>(
          create: (context) => ActiveTodoCount(),
          update: (BuildContext context, TodoList todo,
                  ActiveTodoCount? activeTodoCount) =>
              activeTodoCount!..update(todo),
        ),
        ChangeNotifierProxyProvider3(
          create: (context) => FilteredTodos(),
          update: (BuildContext context,
                  TodoList todoLIst,
                  TodoSearch todoSearch,
                  TodoFilter todoFilter,
                  FilteredTodos? filteredTodo) =>
              filteredTodo!..update(todoFilter, todoSearch, todoLIst),
        )
      ],
      child: MaterialApp(
        title: 'TODOS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const TodosPage(),
      ),
    );
  }
}

```

# Screen

## 기본

```dart
class TodosPage extends StatefulWidget {
  const TodosPage({super.key});

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
                vertical: 20.0, horizontal: 40.0),
            child: Column(
              children: [
                TodoHeader(),
                CreateTodo(),
                SearchAndFilterTodo(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

## TodoHeader

```dart
class TodoHeader extends StatelessWidget {
  const TodoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('TODO'),
        Text(
            '${context.watch<ActiveTodoCount>().state.activeTodoCount} items left'),
      ],
    );
  }
}
```

- 아래에서 ActiveTodoCount는 0이라는 값으로 create되었지만, 바로 update가 실행되기 때문에 값이 갱신 됨

```dart
ChangeNotifierProxyProvider<TodoList, ActiveTodoCount>(
  create: (context) => ActiveTodoCount(),
  update: (BuildContext context, TodoList todo,
    ActiveTodoCount? activeTodoCount) =>
      activeTodoCount!..update(todo),
),
```

## CreateTodo

```dart

class CreateTodo extends StatefulWidget {
  const CreateTodo({super.key});

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final _newTodoController = TextEditingController();

  @override
  void dispose() {
    _newTodoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _newTodoController,
      decoration: InputDecoration(labelText: '해야 할 일'),
      onSubmitted: (String newToDoDescription) {
        if (newToDoDescription != null &&
            newToDoDescription.trim().isNotEmpty) {
          /// ✅ 할 일 추가
          /// 할 일을 추가하면 거기에 의존하고 있던 ActiveTodo, FilteredTodo도 전부 업데이트 됨
          context.read<TodoList>().addTodo(newToDoDescription);
          _newTodoController.clear();
        }
      },
    );
  }
}
```

## SearchAndFilterTodo

```dart

class SearchAndFilterTodo extends StatelessWidget {
  SearchAndFilterTodo({super.key});
  //searchTerm을 onChanged 메서드에서 처리하면 글자를 쓸 때마다 호출되기 때문에 너무 잦음 (서버 통신이라도 하면 너무 잦은 통신)
  //Debounce 클래스를 만들어서 Timer로 찾는 단어를 보여줄 예정
  final debounce = Debounce(milliseconds: 1000);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: '할 일 검색',
            border: InputBorder.none,
            filled: true,
            prefix: Icon(Icons.search),
          ),
          onChanged: (String searchTerm) {
            if (searchTerm != null) {
              ///찾는 단어를 1000 milliseconds마다 찾음 (단어가 바뀔 때마다 찾는 게 아님)
              debounce.run(
                () {
                  ///FilteredTodo가 TodoSearch에 의존하고 있기 때문에 함께 업데이트 됨
                  context.read<TodoSearch>().setSearchTerm(searchTerm);
                },
              );
            }
          },
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            filtterButton(context, Filter.all),
            filtterButton(context, Filter.active),
            filtterButton(context, Filter.completed),
          ],
        ),
        ///할 일 리스트를 보여주는 위젯
        ShowTodo(),
      ],
    );
  }

  Widget filtterButton(BuildContext context, Filter filter) {
    return TextButton(
      onPressed: () {
        ///FilteredTodo가 TodoFilter에 의존하고 있기 때문에 함께 업데이트 됨
        context.read<TodoFilter>().changFilter(filter);
      },
      child: Text(
        filter == Filter.all
            ? 'All'
            : filter == Filter.active
                ? 'active'
                : 'completed',
        style: TextStyle(
          color: textColor(context, filter),
        ),
      ),
    );
  }

  Color textColor(BuildContext context, Filter filter) {
    final currentFilter = context.watch<TodoFilter>().state.filter;
    return currentFilter == filter ? Colors.blue : Colors.grey;
  }
}

```

## ShowTodo

```dart

class ShowTodo extends StatelessWidget {
  const ShowTodo({super.key});

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<FilteredTodos>().state.filteredTodos;

    Widget showBackground(int direction) {
      return Container(
        height: 30,
        margin: const EdgeInsets.all(4.0),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        color: Colors.red,
        alignment:
            direction == 1 ? Alignment.centerLeft : Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          size: 30,
          color: Colors.white,
        ),
      );
    }

    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemCount: todos.length,
      separatorBuilder: (context, index) {
        return const Divider(
          color: Colors.grey,
          thickness: 0.4,
        );
      },
      itemBuilder: (context, index) {
        return Dismissible(
          //right -> left swife gesture
          background: showBackground(1),
          //left -> right swife gesture
          secondaryBackground: showBackground(2),
          key: ValueKey(todos[index].id),
          //삭제될 때
          onDismissed: (_) {
            context.read<TodoList>().removeTodo(todos[index].id);
          },
          //삭제될 때 컨펌받기
          //Future<bool?>를 리턴해야 해서 showDialog를 닫을 때, bool값을 리턴했음
          confirmDismiss: (_) {
            return showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: const Text('삭제하시겠어요?'),
                  content: const Text('이 할 일을 삭제하시겠어요?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('삭제'),
                    ),
                  ],
                );
              },
            );
          },
          child: TodoItem(todo: todos[index]),
        );
      },
    );
  }
}

```

## TodoItem

```dart

class TodoItem extends StatefulWidget {
  final Todo todo;
  const TodoItem({super.key, required this.todo});

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  late final TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: widget.todo.isCompleted,
        onChanged: (value) {
          ///FilteredTodo, ActiveTodo 모두 TodoList에 의존하고 있기 때문에 이 때 업데이트 됨
          context.read<TodoList>().toggleTodo(widget.todo.id);
        },
      ),
      title: Text(widget.todo.description),
      
      //todo descripttion 수정
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            bool _error = false;
            _textController.text = widget.todo.description;

            ///Dialog는 TodoItem의 child 위젯이 아니기 때문에 StatefulBuilder로 감싸줌
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: const Text('할 일 수정하기'),
                  content: TextField(
                    controller: _textController,
                    autofocus: true,
                    decoration: InputDecoration(
                        errorText: _error ? 'value cannot be empty' : null),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () {
                        //StatefulBuilder로 감쌌기 때문에 setSate가 가능
                        //이렇게 해야 에러메시지가 뜰 수 있음
                        setState(
                          () {
                            _error =
                                _textController.text.isEmpty ? true : false;

                            if (!_error) {
                              context.read<TodoList>().editDescription(
                                  widget.todo.id, _textController.text);
                              Navigator.pop(context);
                            }
                          },
                        );
                      },
                      child: const Text('수정'),
                    )
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

```

## Debounce

- 할 일을 검색할 때, 검색 텍스트필드가 [onChanged](https://www.notion.so/todoApp-b7eaf33b541f420a97835dc5462d13fd?pvs=21) 될 때마다 단어를 검색하게 해놓았으나, 그렇게 하면 너무 자주 검색됨 (서버 통신이라도 하게 되면?)
- 그래서 500 milliseconds 마다 검색되도록 설정함

```
import 'dart:async';

import 'package:flutter/material.dart';

class Debounce {
  final int milliseconds;

  Debounce({this.milliseconds = 500});

  Timer? _timer;

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

```

- 적용된 곳

```dart
//선언
final debounce = Debounce(milliseconds: 1000);

//사용
onChanged: (String searchTerm) {
  if (searchTerm != null) {
    ///찾는 단어를 1000 milliseconds마다 찾음 (단어가 바뀔 때마다 찾는 게 아님)
    debounce.run(
      () {
        context.read<TodoSearch>().setSearchTerm(searchTerm);
      },
    );
  }
},
```
