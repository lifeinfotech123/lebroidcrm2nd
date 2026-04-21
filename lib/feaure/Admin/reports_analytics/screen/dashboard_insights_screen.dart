import 'package:flutter/material.dart';

class DashboardInsightsScreen extends StatelessWidget {
  const DashboardInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Insights'), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: const Center(child: Text('AI-Powered Business Insights and Analytics')),
    );
  }
}
