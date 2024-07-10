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
