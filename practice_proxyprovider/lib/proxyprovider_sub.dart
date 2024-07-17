import 'package:flutter/material.dart';
import 'package:practice_proxyprovider/main.dart';
import 'package:practice_proxyprovider/proxyprovider.dart';
import 'package:provider/provider.dart';

class ProxyProviderSubExample extends StatelessWidget {
  const ProxyProviderSubExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: ShowUserStatus(),
      ),
    );
  }
}
