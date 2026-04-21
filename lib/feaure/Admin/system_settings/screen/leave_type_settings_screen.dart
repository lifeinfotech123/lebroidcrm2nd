import 'package:flutter/material.dart';

class LeaveTypeSettingsScreen extends StatelessWidget {
  const LeaveTypeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leave Type Settings'), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: const Center(child: Text('Global Leave Type Configuration')),
    );
  }
}
