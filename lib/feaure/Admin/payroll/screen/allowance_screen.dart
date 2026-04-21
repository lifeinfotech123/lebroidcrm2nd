import 'package:flutter/material.dart';

class AllowanceScreen extends StatelessWidget {
  const AllowanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Allowance'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, size: 80, color: Colors.blueAccent),
            SizedBox(height: 16),
            Text(
              'Employee Allowances',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Manage employee bonuses and allowances.'),
          ],
        ),
      ),
    );
  }
}
