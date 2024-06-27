import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Translations {
  const Translations(this._value);
  final int _value;

  String get title => 'You clicked $_value times';
}

class AnotherTranslations {
  const AnotherTranslations(this._value);
  final int _value;

  String get title => 'Another counter: $_value';
}

class ProxyProvProxyProvTEST extends StatefulWidget {
  const ProxyProvProxyProvTEST({super.key});

  @override
  State<ProxyProvProxyProvTEST> createState() => _ProxyProvProxyProvTESTState();
}

class _ProxyProvProxyProvTESTState extends State<ProxyProvProxyProvTEST> {
  int counter1 = 0;
  int counter2 = 0;

  void incrementCounter1() {
    setState(() {
      counter1++;
      print('counter1: $counter1');
    });
  }

  void incrementCounter2() {
    setState(() {
      counter2++;
      print('counter2: $counter2');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProxyProvider Example'),
      ),
      body: Center(
        child: MultiProvider(
          providers: [
            ProxyProvider0<int>(
              update: (_, __) => counter1,
            ),
            ProxyProvider<int, Translations>(
              update: (_, int value, __) => Translations(value),
            ),
            ProxyProvider0<int>(
              update: (_, __) => counter2,
            ),
            
            ProxyProvider<int, AnotherTranslations>(
              update: (_, int value, __) => AnotherTranslations(value),
            ),
          ],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ShowTranslations(),
              const ShowAnotherTranslations(),
              const SizedBox(height: 20.0),
              IncreaseButton(
                  increment: incrementCounter1, label: 'Increment Counter 1'),
              IncreaseButton(
                  increment: incrementCounter2, label: 'Increment Counter 2'),
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
    return Consumer<Translations>(
      builder: (context, translations, child) {
        return Text(
          translations.title,
          style: TextStyle(fontSize: 28.0),
        );
      },
    );
  }
}

class ShowAnotherTranslations extends StatelessWidget {
  const ShowAnotherTranslations({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AnotherTranslations>(
      builder: (context, anotherTranslations, child) {
        return Text(
          anotherTranslations.title,
          style: TextStyle(fontSize: 28.0),
        );
      },
    );
  }
}

class IncreaseButton extends StatelessWidget {
  final VoidCallback increment;
  final String label;
  const IncreaseButton({
    super.key,
    required this.increment,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: increment,
      child: Text(
        label,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }
}
