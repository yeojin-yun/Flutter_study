import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_basic/main.dart';
import 'package:riverpod_basic/providers/user_provider.dart';
import 'package:riverpod_basic/services/apiservice.dart';
import 'package:riverpod_basic/utils/style.dart';

class JsonPlaceholderScreen extends ConsumerStatefulWidget {
  JsonPlaceholderScreen({super.key});

  @override
  ConsumerState<JsonPlaceholderScreen> createState() =>
      _JsonPlaceholderScreenState();
}

class _JsonPlaceholderScreenState extends ConsumerState<JsonPlaceholderScreen> {
  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        ref.read(userStateProvider.notifier).fetchUserList();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = ref.watch(userStateProvider);

    debugPrint('${userProvider.status}');
    debugPrint('${userProvider.user}');
    debugPrint('${userProvider.error}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('jsonplaceholder'),
      ),
      body: Center(
        child: Text(
          'json',
          style: style.bodyStyle,
        ),
      ),
    );
  }
}
