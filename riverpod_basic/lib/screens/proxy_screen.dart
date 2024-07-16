import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_basic/main.dart';
import 'package:riverpod_basic/utils/style.dart';

class ProxyScreen extends ConsumerWidget {
  const ProxyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterState = ref.watch(counterProvider);
    final counterNotifier = ref.read(counterProvider.notifier);
    final countString = ref.watch(proxyProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('proxy'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${counterState.count}',
              style: style.bodyStyle,
            ),
            Divider(),
            Text(
              countString,
              style: style.bodyStyle,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'plus button',
            onPressed: () {
              counterNotifier.increment();
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: 'minus button',
            onPressed: () {
              counterNotifier.decrement();
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
