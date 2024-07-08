import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udemy_provider_todoapp/models/todo_model.dart';
import 'package:udemy_provider_todoapp/providers/providers.dart';
import 'package:udemy_provider_todoapp/utils/debounce.dart';

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

class TodoHeader extends StatelessWidget {
  const TodoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('TODO'),
        Text(
            '${context.watch<ActivieTodoCount>().state.activeTodoCount} items left'),
      ],
    );
  }
}

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
          context.read<TodoList>().addTodo(newToDoDescription);
          _newTodoController.clear();
        }
      },
    );
  }
}

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
        ShowTodo(),
      ],
    );
  }

  Widget filtterButton(BuildContext context, Filter filter) {
    return TextButton(
      onPressed: () {
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
