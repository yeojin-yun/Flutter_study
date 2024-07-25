import 'package:flutter/material.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});
  final TextStyle textStyle = const TextStyle(fontSize: 20);
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('할 일'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  '남은 할 일 n개',
                  style: textStyle,
                  textAlign: TextAlign.end,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: '할 일',
                            filled: true,
                            fillColor: Colors.green.shade100,
                            suffixIcon: TextButton(
                              child: const Text('추가'),
                              onPressed: () {},
                            )),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: '할 일',
                            filled: true,
                            fillColor: Colors.green.shade100,
                            suffixIcon: TextButton(
                              child: const Text('추가'),
                              onPressed: () {},
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
