import 'package:flutter/material.dart';

class ExpenseReportsScreen extends StatelessWidget {
  const ExpenseReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Reports'), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: const Center(child: Text('Generate Expense and Spending Reports')),
    );
  }
}
