import 'package:flutter/material.dart';

class BreakCategoryScreen extends StatelessWidget {
  const BreakCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Break Category'), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: const Center(child: Text('Global Configuration for Break Types')),
    );
  }
}
