import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Counter with ChangeNotifier {
  int count = 0;

  void increment() {
    count++;
    notifyListeners();
  }
}

class Translations with ChangeNotifier {
  late int _value; //update에서 값이 초기화될 예정이므로

  void update(Counter counter) {
    _value = counter.count;
    debugPrint('value: $_value');
    notifyListeners();
  }

  String get title => 'You clicked $_value times';
}

class ChgNotiProvChgNotiProxyProv extends StatefulWidget {
  const ChgNotiProvChgNotiProxyProv({super.key});

  @override
  State<ChgNotiProvChgNotiProxyProv> createState() =>
      _ChgNotiProvChgNotiProxyProvState();
}

class _ChgNotiProvChgNotiProxyProvState
    extends State<ChgNotiProvChgNotiProxyProv> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('5. ChangeNotifierProvider ChagneNotifierProxyProvider'),
      ),
      body: Center(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => Counter(),
            ),
            ChangeNotifierProxyProvider<Counter, Translations>(
              create: (context) => Translations(),
              update:
                  (BuildContext _, Counter count, Translations? translations) {
                translations!..update(count);
                return translations;
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
