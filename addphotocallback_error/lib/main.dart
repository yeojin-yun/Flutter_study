import 'package:addphotocallback_error/pages/counter_page.dart';
import 'package:addphotocallback_error/pages/dialog_page.dart';
import 'package:addphotocallback_error/pages/navigator_page.dart';
import 'package:addphotocallback_error/provider/counter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Counter>(
      create: (context) => Counter(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'addPostFrameCallback'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: [
            ListTile(
              title: const Text(
                'Counter page',
                style: TextStyle(fontSize: 20),
              ),
              subtitle: const Text(
                'initState에서 provider 접근',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CounterPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Dialog page',
                style: TextStyle(fontSize: 20),
              ),
              subtitle: const Text(
                'initState에서 showDialog\n특정 조건에서 showDialog',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DialogPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Navigator page',
                style: TextStyle(fontSize: 20),
              ),
              subtitle: const Text(
                '특정 조건에서 Navigator push',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NavigatorPage(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
