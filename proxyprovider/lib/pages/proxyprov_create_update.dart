import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Translations {
  late int _value; //update시 값이 주어진 것이므로 late 키워드 사용

  update(int newValue) {
    _value = newValue;
  }

  String get title => 'You clicked $_value times';
}

class ProxyProvCreateUpdate extends StatefulWidget {
  const ProxyProvCreateUpdate({super.key});

  @override
  State<ProxyProvCreateUpdate> createState() => _ProxyProvCreateUpdateState();
}

class _ProxyProvCreateUpdateState extends State<ProxyProvCreateUpdate> {
  int counter = 0;

  void increment() {
    setState(() {
      counter++;
      print('counter: $counter');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProxyProvider create/update'),
      ),
      body: Center(
        child: ProxyProvider0<Translations>(
          //Translations 객체를 생성 -> 이제부터 update에서 Translations의 객체에 접근할 수 있게 됨
          //생성 시 한 번만 호출됨
          create: (context) => Translations(),
          //create했기 때문에 이제부터 update에서 Translations를 받아서 쓸 수 있음 (두 번째 인자)
          //여기서는 counter 값이 바뀔 때마다 Translations 객체의 값을 업데이트 함 (그래서 Translations 안에 update 함수 만들었음)
          //업데이트 된 translations 객체가 return되어 다른 위젯에서 사용 가능하게 됨 (접근해서 값 사용)
          update: (_, Translations? translations) {
            translations!.update(counter); //옵셔널 타입이므로 ! 써줌
            debugPrint('--${translations._value}');
            debugPrint('${translations.title}');
            return translations;
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //const로 바뀌면 UI 안 바뀜
              ShowTranslations(),
              const SizedBox(height: 20.0),
              IncreaseButton(increment: increment),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowTranslations extends StatelessWidget {
  const ShowTranslations({super.key});

  @override
  Widget build(BuildContext context) {
    final String title = context.watch<Translations>().title;
    debugPrint('===${title}');
    return Text(
      title,
      style: const TextStyle(fontSize: 28.0),
    );
  }
}

class IncreaseButton extends StatelessWidget {
  final VoidCallback increment;
  const IncreaseButton({
    super.key,
    required this.increment,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: increment,
      child: const Text(
        'INCREASE',
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }
}
