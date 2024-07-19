import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_basic/providers/counter.dart';
import 'package:riverpod_basic/providers/user_provider.dart';
import 'package:riverpod_basic/repository/user_repository.dart';

import 'package:riverpod_basic/services/apiservice.dart';
import 'package:riverpod_basic/utils/routes.dart';

final counterProvider = StateNotifierProvider<CounterProvider, CounterState>(
  (ref) => CounterProvider(),
);

final proxyProvider = StateProvider<String>((ref) {
  final int count = ref.watch(counterProvider).count;
  return '현재 count는? $count';
});

final userRepository = Provider<UserRepository>(
  (ref) => UserRepository(apiservice: Apiservice(dio: Dio())),
);
final userStateProvider = StateNotifierProvider<UserStateProvider, UserState>(
  (ref) {
    final userReposit = ref.read(userRepository);
    return UserStateProvider(userReposit);
  },
);
void main() {
  runApp(
    // 앱의 최상위에 ProviderScope를 추가
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_riverpod',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
      routes: Routes.routes,
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('flutter_riverpod'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          MenuListTile(
            title: '카운터',
            onTap: () {
              Navigator.pushNamed(context, Routes.counter);
            },
          ),
          MenuListTile(
            title: 'proxy',
            onTap: () {
              Navigator.pushNamed(context, Routes.proxy);
            },
          ),
          MenuListTile(
            title: 'jsonplaceholder',
            onTap: () {
              Navigator.pushNamed(context, Routes.json);
            },
          ),
          MenuListTile(
            title: '할 일',
            onTap: () {
              Navigator.pushNamed(context, Routes.todo);
            },
          ),
          MenuListTile(
            title: '프로필',
            onTap: () {
              Navigator.pushNamed(context, Routes.profile);
            },
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MenuListTile extends StatelessWidget {
  const MenuListTile({super.key, required this.title, required this.onTap});
  final String title;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
