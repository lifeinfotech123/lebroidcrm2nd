import 'package:flutter/material.dart';

class RoleSettingsScreen extends StatelessWidget {
  const RoleSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Role Settings'), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: const Center(child: Text('Global Role Options')),
    );
  }
}
