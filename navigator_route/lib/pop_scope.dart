import 'package:flutter/material.dart';
import 'package:navigator_route/routes.dart';

class PopScopeScreen extends StatefulWidget {
  const PopScopeScreen({super.key});

  @override
  State<PopScopeScreen> createState() => _PopScopeScreenState();
}

class _PopScopeScreenState extends State<PopScopeScreen> {
  @override
  Widget build(BuildContext context) {
    debugPrint('First Screen build ${DateTime.now()}');
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.popScopeSub1);
              },
              child: const Text('1. 일반적인 상황'),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.popScopeSub2, (route) => false);
              },
              child: const Text('2. 네비게이션 마지막 스택일 때'),
            )
          ],
        ),
      ),
    );
  }
}

class PopScopeSubScreen1 extends StatefulWidget {
  const PopScopeSubScreen1({super.key});

  @override
  State<PopScopeSubScreen1> createState() => _PopScopeSubScreen1State();
}

class _PopScopeSubScreen1State extends State<PopScopeSubScreen1> {
  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('현재 창을 닫으시겠습니까?'),
          content: const Text(
            '입력 중이던 내용은 저장되지 않아요.',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('취소'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('나가기'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // canPop: Navigator.of(context).canPop(),
      canPop: false,
      onPopInvoked: (didPop) async {
        debugPrint("--------------------------------");
        if (didPop) {
          debugPrint('didPop true : ${DateTime.now()}');
          return;
        }
        final bool shouldPop = await _showBackDialog() ?? false;
        debugPrint(
            'popInvoke $didPop | shouldPop = $shouldPop | time = ${DateTime.now()}');
        if (context.mounted && shouldPop) {
          //pushReplacement
          // Navigator.pushReplacementNamed(context, Routes.main);
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sub Screen'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('canPop == true'),
            ],
          ),
        ),
      ),
    );
  }
}

class PopScopeSubScreen2 extends StatefulWidget {
  const PopScopeSubScreen2({super.key});

  @override
  State<PopScopeSubScreen2> createState() => _PopScopeSubScreen2State();
}

class _PopScopeSubScreen2State extends State<PopScopeSubScreen2> {
  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('혜택받기를 끝내시겠어요?'),
          content: const Text(
            '무료체험은 가입시에만 가능해요',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('계속하기'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('나가기'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await _showBackDialog() ?? false;
        debugPrint(
            'popInvoke $didPop | shouldPop = $shouldPop | time = ${DateTime.now()}');
        if (context.mounted && shouldPop) {
          //pushReplacement
          // Navigator.pushReplacementNamed(context, Routes.main);
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sub Screen'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('canPop == Navigator.of(context).pop()'),
            ],
          ),
        ),
      ),
    );
  }
}
