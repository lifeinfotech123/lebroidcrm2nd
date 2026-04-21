import 'package:flutter/material.dart';

class DepartmentSettingsScreen extends StatelessWidget {
  const DepartmentSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Department Settings'), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: const Center(child: Text('Global Department Options')),
    );
  }
}
