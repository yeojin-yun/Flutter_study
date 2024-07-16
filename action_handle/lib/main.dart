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
  ///addListener 등록을 위한 프로바디어 객체
  late final AppProvider appProvider;
  //formField를 구별하기 위한 global key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //자동 유효성 검사 -> disabled, always, onUserInteraction이 있음
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  //텍스트 필드에 입력될 값
  String? searchTerm;

  void submit() {
    //✅일단 form이 한 번 submit 된 후에는 모든 form 입력에 대해서는 validation을 수행한다
    autovalidateMode = AutovalidateMode.always;
    //✅form의 현재 상태의 유효성을 체크하여 문제 없으면 form을 save -> TextFromField의 onsaved 메서드 호출됨
    final form = formKey.currentState;
    if (form == null || !form.validate()) return;
    form.save(); //onsaved 메서드 호출
    context.read<AppProvider>().getResult(searchTerm!);
  }

  @override
  void initState() {
    // TODO: implement initState
    ///객체 초기화 및 리스너 등록
    appProvider = context.read<AppProvider>();
    appProvider.addListener(addListener);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    ///리스터 해제 작업(필수)
    appProvider.removeListener(addListener);
    super.dispose();
  }

  void addListener() {
    if (appProvider.state == AppState.success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessPage(),
        ),
      );
    } else if (appProvider.state == AppState.error) {
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
