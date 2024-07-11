import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:statenotifier_statenotifierprovider/providers/bg_color.dart';
import 'package:statenotifier_statenotifierprovider/providers/counter.dart';
import 'package:statenotifier_statenotifierprovider/providers/level.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ///StateNotifierProvider -> 두 개의 타입을 명시함 -> State와 State를 핸들링 하는 클래스
        ///순서가 매우 중요
        StateNotifierProvider<BgColor, BgColorState>(
          create: (context) => BgColor(),
        ),
        StateNotifierProvider<Counter, CounterState>(
          create: (context) => Counter(),
        ),
        StateNotifierProvider<CustomLevel, Level>(
          create: (context) => CustomLevel(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    ///사용하게 될 state
    final colorState = context.watch<BgColorState>().color;
    final level = context.watch<Level>();
    final countState = context.watch<CounterState>().count;
    return Scaffold(
      backgroundColor: level == Level.bronze
          ? Colors.white
          : level == Level.silver
              ? Colors.grey
              : Colors.yellow,
      appBar: AppBar(
        backgroundColor: colorState,
        title: const Text(
          'App Bar',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$countState',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20),
            Text(
              '${level.toString()}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              context.read<Counter>().increment();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              context.read<BgColor>().chnageColor();
            },
            tooltip: 'Change Color',
            child: const Icon(Icons.color_lens_outlined),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
