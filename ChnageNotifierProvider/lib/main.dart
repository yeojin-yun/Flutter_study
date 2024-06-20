import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:provier_overview_03/moongchi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Moongchi(name: '뭉치', breed: '파피용', age: 6),
      child: MaterialApp(
        title: 'Provider',
        debugShowCheckedModeBanner: false,
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
  MyHomePage({super.key});

  TextStyle labelStyle = const TextStyle(fontSize: 30, color: Colors.black);
  TextStyle buttonStyle = const TextStyle(fontSize: 20, color: Colors.purple);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        title: const Text('Provider'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              // 'name: ${Provider.of<Moongchi>(context).name}',
              // 'name: ${context.read<Moongchi>().name}',
              // 'name: ${context.watch<Moongchi>().name}',
              'name: ${context.select<Moongchi, String>((Moongchi mc) => mc.name)}',
              style: labelStyle,
            ),
            const SizedBox(height: 10.0),
            Text(
              // 'breed: ${Provider.of<Moongchi>(context).breed}',
              // 'breed: ${context.read<Moongchi>().breed}',
              // 'breed: ${context.watch<Moongchi>().breed}',
              'breed: ${context.select<Moongchi, String>((Moongchi mc) => mc.breed)}',
              style: labelStyle,
            ),
            const SizedBox(height: 10.0),
            Divider(
              color: Colors.purple[400],
              thickness: 2,
            ),
            Text(
              // 'age: ${Provider.of<Moongchi>(context).age}',
              // 'age: ${context.watch<Moongchi>().age}',
              // 'age: ${context.read<Moongchi>().age}',
              'age: ${context.select<Moongchi, int>((Moongchi mc) => mc.age)}',
              style: labelStyle,
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // Provider.of<Moongchi>(context, listen: false).resetAge();
                    context.read<Moongchi>().resetAge();
                  },
                  child: Text(
                    '나이 리셋',
                    style: buttonStyle,
                  ),
                ),
                const SizedBox(width: 20),
                OutlinedButton(
                  onPressed: () {
                    // Provider.of<Moongchi>(context, listen: false).getAge();
                    context.read<Moongchi>().getAge();
                  },
                  child: Text(
                    '나이 추가',
                    style: buttonStyle,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
