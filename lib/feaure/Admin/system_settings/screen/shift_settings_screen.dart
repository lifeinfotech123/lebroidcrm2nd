import 'package:flutter/material.dart';

class ShiftSettingsScreen extends StatelessWidget {
  const ShiftSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shift Settings'), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: const Center(child: Text('Global Shift Options')),
    );
  }
}
