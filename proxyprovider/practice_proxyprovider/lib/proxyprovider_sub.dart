import 'package:flutter/material.dart';
import 'package:practice_proxyprovider/main.dart';
import 'package:practice_proxyprovider/proxyprovider.dart';
import 'package:provider/provider.dart';

class ProxyProviderSubExample extends StatefulWidget {
  const ProxyProviderSubExample({super.key});

  @override
  State<ProxyProviderSubExample> createState() =>
      _ProxyProviderSubExampleState();
}

class _ProxyProviderSubExampleState extends State<ProxyProviderSubExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<User>(builder: (context, value, child) {
          return Text(value.status);
        }),
      ),
    );
  }
}

class ShowLabel extends StatelessWidget {
  const ShowLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final String statue = context.watch<User>().status;
    return Text(statue);
  }
}
