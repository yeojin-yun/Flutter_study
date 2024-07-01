import 'package:action_handle/provider.dart';
import 'package:action_handle/success_page.dart';
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
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: MaterialApp(
        title: 'addListener',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? searchTerm;

  Future<void> submit() async {
    //일단 form이 한 번 submit 된 후에는 모든 form 입력에 대해서는 validation을 수행한다
    autovalidateMode = AutovalidateMode.always;
    final form = formKey.currentState;
    if (form == null || !form.validate()) return;
    form.save();

    try {
      await context.read<AppProvider>().getResult(searchTerm!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessPage(),
        ),
      );
    } catch (e) {
      debugPrint('----- [2]catch $e------');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('문제 발생'),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppProvider>().state;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Form(
          key: formKey,
          autovalidateMode: autovalidateMode,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              TextFormField(
                autofocus: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Search'),
                  prefixIcon: Icon(Icons.search),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Search term required';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  searchTerm = value;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: appState == AppState.loading ? null : submit,
                child: Text(
                  appState == AppState.loading ? '로딩 중...' : '제출하기',
                  style: const TextStyle(fontSize: 24.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
