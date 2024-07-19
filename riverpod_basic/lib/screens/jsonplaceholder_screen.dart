import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    Widget showWidget() {
      if (userProvider.status == Status.error) {
        return Text('에러가 발생했습니다.');
      } else if (userProvider.status == Status.loaded) {
        return ListView.separated(
          padding: EdgeInsets.all(16),
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey[300],
          ),
          itemCount: userProvider.user.length,
          itemBuilder: (context, index) {
            final user = userProvider.user[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name),
                Text(user.phone),
                Text(user.email),
                Text(user.website),
                Text(user.company.name),
                Text(
                    "${user.address.zipcode}, ${user.address.city} ${user.address.street}"),
              ],
            );
          },
        );
      } else if (userProvider.status == Status.loading) {
        return CircularProgressIndicator();
      } else {
        return Text('data가 없습니다.');
      }
    }

    // if (userProvider.status == Status.error) {
    //   WidgetsBinding.instance.addPostFrameCallback(
    //     (_) {
    //       showDialog(
    //         context: context,
    //         builder: (context) {
    //           return AlertDialog(
    //             title: Text('Error'),
    //             actions: [
    //               TextButton(
    //                   onPressed: () {
    //                     Navigator.pop(context);
    //                     Navigator.pop(context);
    //                   },
    //                   child: Text('확인'))
    //             ],
    //           );
    //         },
    //       );
    //     },
    //   );
    // }
    ref.listen<UserState>(
      userStateProvider,
      (UserState? previous, UserState next) {
        if (next.status == Status.error) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text('확인'))
                ],
              );
            },
          );
        }
      },
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('jsonplaceholder'),
        ),
        body: Center(child: showWidget()),
      ),
    );
  }
}
