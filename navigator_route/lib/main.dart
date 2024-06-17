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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> menuList = ["navigator_route", "PopScope"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
        centerTitle: true,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: menuList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(menuList[index]),
              onTap: () {
                if (index == 0) {
                  Navigator.pushNamed(context, Routes.nav);
                } else {
                  Navigator.pushNamed(context, Routes.popScope);
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({super.key});

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigator_route'),
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

// //
// import 'package:flutter/material.dart';

// void main() => runApp(const NavigatorPopHandlerApp());

// class NavigatorPopHandlerApp extends StatelessWidget {
//   const NavigatorPopHandlerApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       initialRoute: '/home',
//       routes: <String, WidgetBuilder>{
//         '/home': (BuildContext context) => const _HomePage(),
//         '/two': (BuildContext context) => const _PageTwo(),
//       },
//     );
//   }
// }

// class _HomePage extends StatefulWidget {
//   const _HomePage();

//   @override
//   State<_HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<_HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text('Page One'),
//             TextButton(
//               onPressed: () {
//                 // Navigator.of(context).pushReplacementNamed('/two');
//                 Navigator.of(context).pushNamed('/two');
//               },
//               child: const Text('Next page'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _PageTwo extends StatefulWidget {
//   const _PageTwo();

//   @override
//   State<_PageTwo> createState() => _PageTwoState();
// }

// class _PageTwoState extends State<_PageTwo> {
//   /// Shows a dialog and resolves to true when the user has indicated that they
//   /// want to pop.
//   ///
//   /// A return value of null indicates a desire not to pop, such as when the
//   /// user has dismissed the modal without tapping a button.
//   Future<bool?> _showBackDialog() {
//     return showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Are you sure?'),
//           content: const Text(
//             'Are you sure you want to leave this page?',
//           ),
//           actions: <Widget>[
//             TextButton(
//               style: TextButton.styleFrom(
//                 textStyle: Theme.of(context).textTheme.labelLarge,
//               ),
//               child: const Text('Nevermind'),
//               onPressed: () {
//                 Navigator.pop(context, false);
//               },
//             ),
//             TextButton(
//               style: TextButton.styleFrom(
//                 textStyle: Theme.of(context).textTheme.labelLarge,
//               ),
//               child: const Text('Leave'),
//               onPressed: () {
//                 Navigator.pop(context, true);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text('Page Two'),
//             PopScope(
//               canPop: false,
//               onPopInvoked: (bool didPop) async {
//                 debugPrint('$didPop');
//                 if (didPop) {
//                   return;
//                 }
//                 final bool shouldPop = await _showBackDialog() ?? false;
//                 if (context.mounted && shouldPop) {
//                   Navigator.pop(context);
//                 }
//               },
//               child: TextButton(
//                 onPressed: () async {
//                   final bool shouldPop = await _showBackDialog() ?? false;
//                   if (context.mounted && shouldPop) {
//                     Navigator.pop(context);
//                   }
//                 },
//                 child: const Text('Go back'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
