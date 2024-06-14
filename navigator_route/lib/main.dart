import 'package:flutter/material.dart';
import 'package:navigator_route/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(),
      initialRoute: '/',
      routes: Routes.routes,
      onGenerateRoute: (settings) {
        if (settings.name == Routes.second) {
          debugPrint('settings name = ${settings.name}');
          final arguments = settings.arguments as Map<String, dynamic>;
          final String title = arguments['title'] as String;
          final String content = arguments['content'] as String;

          return MaterialPageRoute(
            builder: (context) {
              return SecondScreen(title: title, content: content);
            },
          );
        } else {
          return MaterialPageRoute(
            builder: (context) {
              return const UnknownScreen();
            },
          );
        }
      },
    );
  }
}

// class Arguments {
//   final String title;
//   final String message;

//   Arguments(this.title, this.message);
// }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메인화면'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.first,
                  arguments: {
                    'name': '윤순진',
                    'age': '23짤',
                  },
                );
              },
              child: const Text('1. routes 정의된 화면'),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.second,
                  arguments: {
                    'title': '백설공주',
                    'content': '백설기 먹고 싶다.',
                  },
                );
              },
              child: const Text('2. routes에 정의되지 않은 화면'),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/unknown',
                );
              },
              child: const Text('3. 아무곳에도 정의되지 않은 화면'),
            )
          ],
        ),
      ),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String name = arguments['name'] as String;
    final String age = arguments['age'] as String;

    return Scaffold(
      backgroundColor: Colors.green[200],
      appBar: AppBar(
        title: const Text('1. routes에 정의된 화면'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('이름: $name'),
            Text('나이: $age'),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key, required this.title, required this.content});

  final String title;
  final String content;
  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: const Text('2. routes에 정의되지 않은 화면'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('제목: ${widget.title}'),
            Text('내용: ${widget.content}'),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.main,
                );
              },
              child: const Text('메인으로 가기'),
            ),
          ],
        ),
      ),
    );
  }
}

class UnknownScreen extends StatefulWidget {
  const UnknownScreen({super.key});

  @override
  State<UnknownScreen> createState() => _UnknownScreenState();
}

class _UnknownScreenState extends State<UnknownScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[200],
      appBar: AppBar(
        title: const Text('3. 아무곳에도 정의되지 않은 화면'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('route 테이블에도, ongenerateRoute에도 등록되지 않았습니다.'),
          ],
        ),
      ),
    );
  }
}
