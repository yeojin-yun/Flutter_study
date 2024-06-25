import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Translations {
  const Translations(this._value);
  final int _value;

  String get title => 'You clicked $_value times';
}

class WhyProxyProv extends StatefulWidget {
  const WhyProxyProv({super.key});

  @override
  State<WhyProxyProv> createState() => _WhyProxyProvState();
}

class _WhyProxyProvState extends State<WhyProxyProv> {
  int counter = 0;

  void increment() {
    setState(() {
      counter++;

      print('counter: $counter');
    });
  }

  @override
  Widget build(BuildContext context) {
    // print('string: ${context.read<Translations>().title}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Why ProxyProvider'),
      ),
      body: Provider<Translations>(
        create: (context) => Translations(counter),
        child: Center(
          child: Builder(builder: (contextA) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ShowTranslations(),
                Text(
                  contextA.read<Translations>().title,
                  style: const TextStyle(fontSize: 28.0),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    increment();
                    debugPrint('${contextA.read<Translations>()._value}');
                    debugPrint(contextA.read<Translations>().title);
                  },
                  child: const Text(
                    'INCREASE',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class ShowTranslations extends StatelessWidget {
  const ShowTranslations({super.key});

  @override
  Widget build(BuildContext context) {
    print('string: ${context.read<Translations>().title}');
    final String title = Provider.of<Translations>(context).title;
    return Text(
      title,
      style: TextStyle(fontSize: 28.0),
    );
  }
}
