// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:practice_proxyprovider/proxyprovider_sub.dart';

class Auth with ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  void changeState() {
    _isLoggedIn = !_isLoggedIn;
    notifyListeners();
  }

  @override
  String toString() => 'Auth(_isLoggedIn: $_isLoggedIn)';
}

class User {
  final bool _isLoggedIn;
  User(this._isLoggedIn);

  String get status => _isLoggedIn ? '로그인 상태입니다.' : '로그아웃 상태입니다.';

  @override
  String toString() => 'User(_isLoggedIn: $_isLoggedIn)';

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other._isLoggedIn == _isLoggedIn;
  }

  @override
  int get hashCode => _isLoggedIn.hashCode;
}

class ProxyProviderExample extends StatelessWidget {
  const ProxyProviderExample({super.key});

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
            const SizedBox(height: 30),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoginButton(
                  title: '로그인 상태 바꾸기',
                ),
              ],
            ),
            const SizedBox(height: 5),
            OutlinedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProxyProviderSubExample(),
                      ));
                },
                child: Text('다음 페이지'))
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
        context.read<Auth>().changeState();
      },
      child: Text(
        title,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }
}
