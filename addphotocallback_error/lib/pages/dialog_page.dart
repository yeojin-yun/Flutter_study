import 'package:addphotocallback_error/provider/counter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogPage extends StatefulWidget {
  const DialogPage({super.key});

  @override
  State<DialogPage> createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {
  @override
  void initState() {
    // TODO: implement initState
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('저는 얼럿입니다.'),
        content: Text('제가 initState에서 나왔나요?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('확인'))
        ],
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int = context.watch<Counter>().number;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dialog Page',
        ),
      ),
      body: Center(
        child: Text(
          '$int',
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
