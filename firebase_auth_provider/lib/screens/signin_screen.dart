import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = '/signIn';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Sign In'),
      ),
    );
  }
}
