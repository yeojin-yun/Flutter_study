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
  //formField를 구별하기 위한 global key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //자동 유효성 검사 -> disabled, always, onUserInteraction이 있음
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  //텍스트 필드에 입력될 값
  String? searchTerm;

  Future<void> submit() async {
    //✅일단 form이 한 번 submit 된 후에는 모든 form 입력에 대해서는 validation을 수행한다
    autovalidateMode = AutovalidateMode.always;
    //✅form의 현재 상태의 유효성을 체크하여 문제 없으면 form을 save -> TextFromField의 onsaved 메서드 호출됨
    final form = formKey.currentState;
    if (form == null || !form.validate()) return;
    form.save(); //onsaved 메서드 호출

    //✅상위 호출부
    try {
      await context.read<AppProvider>().getResult(searchTerm!);
      //✅성공페이지로
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessPage(),
        ),
      );
    } catch (e) {
      //✅여기로 searchTerm=='fail'인 케이스와 error 케이스가 들어옴
      //이런 경우에는 dialog 띄워주기
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
                //✅ 앱 상태에 따라 버튼 액션 다르게 설정
                //(앱 상태가 바뀔 때마다 notifyListener가 호출돼 UI가 다시 그려지므로 반영됨)
                onPressed: appState == AppState.loading ? null : submit,
                child: Text(
                  //✅ 앱 상태에 따라 버튼명 다르게 설정
                  //(앱 상태가 바뀔 때마다 notifyListener가 호출돼 UI가 다시 그려지므로 반영됨)
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
