import 'package:flutter/material.dart';
import 'package:proxyprovider/pages/test.dart';

import 'pages/chgnotiprov_chgnotiproxyprov.dart';
import 'pages/chgnotiprov_proxyprov.dart';
import 'pages/proxyprov_create_update.dart';
import 'pages/proxyprov_proxyprov.dart';
import 'pages/proxyprov_update.dart';
import 'pages/why_proxyprov.dart';

void main() {
  final mc = Moongchi(
      name: '뭉치', age: 6, breed: 'Papillion', birth: 2018, gender: 'Female');
  final mc2 = mc.copyWith(name: "춘희", birth: 2024);
  debugPrint(mc2.name); // 춘희
  debugPrint('${mc2.birth}'); //2024
  debugPrint(mc.name); //뭉치
  debugPrint('${mc.birth}'); //2018

  runApp(const MyApp());
}

class Moongchi {
  final String name;
  final int age;
  final String breed;
  final int birth;
  final String gender;

  Moongchi(
      {required this.name,
      required this.age,
      required this.breed,
      required this.birth,
      required this.gender});

  Moongchi copyWith(
      {String? name, int? age, String? breed, int? birth, String? gender}) {
    return Moongchi(
        name: name ?? this.name,
        age: age ?? this.age,
        breed: breed ?? this.breed,
        birth: birth ?? this.birth,
        gender: gender ?? this.gender);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProxyProvider Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WhyProxyProv(),
                  ),
                ),
                child: const Text(
                  '1. Why\nProxyProvider',
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProxyProvUpdate(),
                  ),
                ),
                child: const Text(
                  '2. ProxyProvider\nupdate',
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProxyProvCreateUpdate(),
                  ),
                ),
                child: const Text(
                  '3.ProxyProvider\ncreate/update',
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProxyProvProxyProv(),
                  ),
                ),
                child: const Text(
                  '4. ProxyProvider\nProxyProvider',
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[200]),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProxyProvProxyProvTEST(),
                  ),
                ),
                child: const Text(
                  '4-1. TEST',
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChgNotiProvChgNotiProxyProv(),
                  ),
                ),
                child: const Text(
                  '5. ChangeNotifierProvider\nChangeNotifierProxyProvider',
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChgNotiProvProxyProv(),
                  ),
                ),
                child: const Text(
                  '6. ChangeNotifierProvider\nProxyProvider',
                  style: TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
