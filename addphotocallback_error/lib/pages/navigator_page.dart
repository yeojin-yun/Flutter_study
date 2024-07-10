import 'package:addphotocallback_error/provider/counter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({super.key});

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  @override
  Widget build(BuildContext context) {
    final number = context.watch<Counter>().number;
    if (number == 3) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DestinationScreen(),
              ));
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Navigator Page',
        ),
      ),
      body: Center(
        child: Text(
          '$number',
          style: TextStyle(fontSize: 30),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<Counter>().increment();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DestinationScreen extends StatelessWidget {
  const DestinationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('navigator push'),
      ),
    );
  }
}
