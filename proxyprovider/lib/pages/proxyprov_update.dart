import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Translations {
  const Translations(this._value);
  final int _value;

  String get title => 'You clicked $_value times';
}

class ProxyProvUpdate extends StatefulWidget {
  const ProxyProvUpdate({super.key});

  @override
  State<ProxyProvUpdate> createState() => _ProxyProvUpdateState();
}

class _ProxyProvUpdateState extends State<ProxyProvUpdate> {
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
        title: const Text('2. ProxyProvider update'),
      ),
      body: Center(
        child: ProxyProvider0<Translations>(
          //의존하는 Provider의 값이 변할 때
          //ProxyProvider가 리빌드가 될 때
          update: (BuildContext _, Translations? __) {
            debugPrint('--------------');
            return Translations(counter);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ShowTranslations(),
              const SizedBox(height: 20.0),
              IncreaseButton(increment: increment),
            ],
          ),
        ),
      ),
    );
  }
}

// class ShowTranslations extends StatelessWidget {
//   const ShowTranslations({super.key});

//   @override
//   Widget build(BuildContext context) {
//     print('string: ${context.read<Translations>().title}');
//     final String title = Provider.of<Translations>(context).title;
//     return Text(
//       title,
//       style: TextStyle(fontSize: 28.0),
//     );
//   }
// }

// class IncreaseButton extends StatelessWidget {
//   final VoidCallback increment;
//   const IncreaseButton({
//     super.key,
//     required this.increment,
//   });

//   @override
//   Widget build(BuildContext context) {
//     debugPrint('statement');
//     return ElevatedButton(
//       onPressed: increment,
//       child: const Text(
//         'INCREASE',
//         style: TextStyle(fontSize: 20.0),
//       ),
//     );
//   }
// }

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
