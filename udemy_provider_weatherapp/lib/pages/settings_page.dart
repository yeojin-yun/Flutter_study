import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udemy_provider_weatherapp/providers/setting/temp_setting_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListTile(
          title: Text('Temperature Unit'),
          subtitle: Text('Celsius/Fahrenheit (Default: Celsius)'),
          trailing: Switch(
            value: context.watch<TempSettingProvider>().state.tempUnit ==
                TempUnit.celsius,
            onChanged: (value) {
              context.read<TempSettingProvider>().toggleSwitch();
            },
          ),
        ),
      ),
    );
  }
}
