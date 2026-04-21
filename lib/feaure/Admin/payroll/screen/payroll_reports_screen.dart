import 'package:flutter/material.dart';

class PayrollReportsScreen extends StatelessWidget {
  const PayrollReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payroll Reports'), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: const Center(child: Text('Generate Comprehensive Payroll Reports')),
    );
  }
}
