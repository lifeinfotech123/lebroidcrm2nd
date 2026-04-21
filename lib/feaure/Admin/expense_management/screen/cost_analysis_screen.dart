import 'package:flutter/material.dart';

class CostAnalysisScreen extends StatelessWidget {
  const CostAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cost Analysis'), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: const Center(child: Text('Financial Cost and Budget Analysis')),
    );
  }
}
