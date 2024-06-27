import 'package:flutter/material.dart';

import 'package:practice_proxyprovider/proxyprovider_sub.dart';
import 'package:provider/provider.dart';

class Auth with ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

class User {
  final bool _isLoggedIn;
  User(this._isLoggedIn);

  String get status => _isLoggedIn ? '로그인' : '로그아웃';
}

class ProxyProviderExample extends StatefulWidget {
  const ProxyProviderExample({super.key});

  @override
  State<ProxyProviderExample> createState() => _ProxyProviderExampleState();
}

class _ProxyProviderExampleState extends State<ProxyProviderExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProxyProvider'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(context.watch<User>().status),
            const ShowUserStatus(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoginButton(
                  title: '로그인',
                ),
                LoginButton(
                  title: '로그아웃',
                )
              ],
            ),
            OutlinedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProxyProviderSubExample(),
                      ));
                },
                child: Text('next'))
          ],
        ),
      ),
    );
  }
}

class ShowUserStatus extends StatelessWidget {
  const ShowUserStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final String status = context.watch<User>().status;
    debugPrint('Label build -');
    return Text(
      status,
      style: TextStyle(fontSize: 28.0),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key, required this.title});

  final String title;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        title == '로그인'
            ? context.read<Auth>().login()
            : context.read<Auth>().logout();
      },
      child: Text(
        title,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }
}
