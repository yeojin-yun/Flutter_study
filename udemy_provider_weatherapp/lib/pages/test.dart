// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:udemy_provider_weatherapp/main.dart';

// class TestScreen extends ConsumerStatefulWidget {
//   const TestScreen({super.key});

//   @override
//   ConsumerState<TestScreen> createState() => _TestScreenState();
// }

// class _TestScreenState extends ConsumerState<TestScreen> {
//   @override
//   void initState() {
//     // TODO: implement initState

//     WidgetsBinding.instance.addPostFrameCallback(
//       (_) {
//         ref.read(testProvider.notifier).fetchWeather('london');
//       },
//     // );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = ref.watch(testProvider);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('title'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text('${provider.weather.temp}'),
//           Text('${provider.weather.name}'),
//         ],
//       ),
//     );
//   }
// }
