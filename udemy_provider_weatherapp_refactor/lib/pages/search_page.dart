import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>();
  String? _city;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  _submit() {
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form != null && form.validate()) {
      form.save();
      Navigator.pop(context, _city!.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Page'),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          children: [
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextFormField(
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'City name',
                  prefixIcon: Icon(Icons.search),
                  hintText: 'more than 2 character',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().length < 2) {
                    return 'city name must be at least 2 characters long';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _city = newValue;
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _submit,
                child: Text(
                  'How\'s weather?',
                  style: TextStyle(fontSize: 20),
                ))
          ],
        ),
      ),
    );
  }
}
