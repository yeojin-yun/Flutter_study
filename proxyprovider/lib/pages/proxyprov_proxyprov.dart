import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Translations {
  //const 생성자 -> 매번 새로운 객체를 만듦
  const Translations(this._value);
  final int _value;

  String get title => 'You clicked $_value times';
}

class ProxyProvProxyProv extends StatefulWidget {
  const ProxyProvProxyProv({super.key});

  @override
  State<ProxyProvProxyProv> createState() => _ProxyProvProxyProvState();
}

class _ProxyProvProxyProvState extends State<ProxyProvProxyProv> {
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
        title: const Text('4. ProxyProvider ProxyProvider'),
      ),
      body: Center(
        child: MultiProvider(
          providers: [
            //1번 ProxyProvider
            //자체적으로 관리하는 데이터가 없기 때문에 -> create 필요없음
            //(int 값에 의존하는 ProxyProvider)
            ProxyProvider0<int>(
              update: (_, __) => counter,
            ),
            //2번 ProxyProvider
            //BuildContext 사용 안함 => _
            //의존할 값 int => value
            //previous 값 없이 Translations를 생성할 것이므로 => __  -> 항상 새로운 값을 creation함
            ProxyProvider<int, Translations>(
              update: (_, int value, __) => Translations(value),
            )
          ],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ShowTranslations(),
              const SizedBox(height: 20.0),
              IncreaseButton(increment: increment),
              const Test()
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
    debugPrint('Text Widget build');
    final String title = context.watch<Translations>().title;
    return Text(
      title,
      style: TextStyle(fontSize: 28.0),
    );
  }
}

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('TEST Widget build');
    return Builder(builder: (context) {
      return Consumer<int>(builder: (_, value, __) {
        return Text(
          '$value',
          style: TextStyle(fontSize: 28.0),
        );
      });
    });
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
    debugPrint('Button Widget build');
    return ElevatedButton(
      onPressed: increment,
      child: const Text(
        'INCREASE',
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }
}
