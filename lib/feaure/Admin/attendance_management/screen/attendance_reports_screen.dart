import 'package:flutter/material.dart';

class AttendanceReportsScreen extends StatelessWidget {
  const AttendanceReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Reports'), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: const Center(child: Text('Generate Attendance Reports')),
    );
  }
}
