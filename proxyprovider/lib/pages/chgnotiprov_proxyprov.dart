import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Counter with ChangeNotifier {
  int count = 0;

  void increment() {
    count++;
    notifyListeners();
  }
}

//자체적으로 관리하는 State가 없고, 값을 오로지 Counter에 의존하기만 함
//Counter ChangeNotifier가 변할 때마다 Translations 객체를 생성(create)하게 됨
class Translations {
  const Translations(this._value);
  final int _value;

  String get title => 'You clicked $_value times';
}

class ChgNotiProvProxyProv extends StatefulWidget {
  const ChgNotiProvProxyProv({super.key});

  @override
  State<ChgNotiProvProxyProv> createState() => _ChgNotiProvProxyProvState();
}

class _ChgNotiProvProxyProvState extends State<ChgNotiProvProxyProv> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('6. ChangeNotifierProvider ProxyProvider'),
      ),
      body: Center(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<Counter>(
              create: (context) => Counter(),
            ),
            ProxyProvider<Counter, Translations>(
              update: (BuildContext _, Counter counter, Translations? __) {
                return Translations(counter.count);
              },
            )
          ],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ShowTranslations(),
              const SizedBox(height: 20.0),
              IncreaseButton(),
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
    return Text(
      title,
      style: TextStyle(fontSize: 28.0),
    );
  }
}

class IncreaseButton extends StatelessWidget {
  const IncreaseButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<Counter>().increment();
      },
      child: const Text(
        'INCREASE',
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }
}
