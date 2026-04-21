import 'package:flutter/material.dart';

class MultiBranchLocationScreen extends StatelessWidget {
  const MultiBranchLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multi Branch / Location'), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: const Center(child: Text('Manage Multi-Location Hierarchy')),
    );
  }
}
