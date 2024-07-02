import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Widget',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Form Widget'),
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
  //GlobalKey<FormState>의 키 만들기
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction;

  //TextFormField에 입력될 값들
  String name = '';
  String age = '';
  String breed = '';

  void submit() {
    //1.
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(),
        settings: RouteSettings(
            arguments: {"name": name, "age": age, "breed": breed}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  debugPrint('$value');
                  if (value == null || value.isEmpty) {
                    return '이름을 입력하세요';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  debugPrint('저장!!');
                  if (newValue == null) return;
                  name = newValue;
                },
                decoration: const InputDecoration(labelText: '이름'),
              ),
              const SizedBox(height: 30),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '나이를 입력하세요';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  if (newValue == null) return;
                  age = newValue;
                },
                decoration: const InputDecoration(labelText: '나이'),
              ),
              const SizedBox(height: 30),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '견종을 입력하세요';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  if (newValue == null) return;
                  breed = newValue;
                },
                decoration: const InputDecoration(labelText: '견종'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(onPressed: submit, child: const Text('제출하기'))
            ],
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});
  final style = const TextStyle(fontSize: 20);
  @override
  Widget build(BuildContext context) {
    final arg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final name = arg["name"];
    final age = arg["age"];
    final breed = arg["breed"];
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'name: $name',
              style: style,
            ),
            Text(
              'age: $age',
              style: style,
            ),
            Text(
              'breed: $breed',
              style: style,
            ),
          ],
        ),
      ),
    );
  }
}
