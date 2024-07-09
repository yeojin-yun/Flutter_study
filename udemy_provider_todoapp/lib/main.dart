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
