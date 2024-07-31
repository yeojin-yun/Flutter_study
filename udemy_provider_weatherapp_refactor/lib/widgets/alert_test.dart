import 'package:flutter/material.dart';

class AppDialog extends AlertDialog {
  final String customTitle;

  AppDialog({Key? key, required this.customTitle}) : super(key: key);
}
